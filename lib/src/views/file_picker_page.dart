import 'package:firebasestoragemanager/firebasestoragemanager.dart';
import 'package:firebasestoragemanager/src/views/file_upload_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class FilePickerPage extends StatelessWidget {
  const FilePickerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Picker'),
      ),
      body: BlocBuilder<StorageManagerBloc, StorageManagerState>(
        builder: (context, state) {
          return Padding(
            padding: Theme.of(context).pageColumnPadding,
            child: Column(
              children: [
                _buildTopRowBasedOnState(state, context),
                Expanded(
                  child: _buildContentBasedOnState(state, context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopRowBasedOnState(
      StorageManagerState state, BuildContext context) {
    // Customize this method to return different widgets based on the state
    if (state is StorageManagerPickedFiles) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      StyledTextButton(
                        buttonText: 'Cancel',
                        onPressed: () {
                          context.read<StorageManagerBloc>().add(
                                StorageManagerClearPickedFiles(),
                              );
                        },
                      ),
                      const Gap(8),
                      StyledFilledButton(
                        buttonText: 'Upload Single File',
                        onPressed: () async {
                          var file = context.read<StorageManagerBloc>().state
                              as StorageManagerPickedFiles;
                          context.read<StorageManagerBloc>().add(
                                StorageManagerUploadSingleFromRawData(
                                  file: file.files.first,
                                ),
                              );

                          // Push FileUploadPage and wait for it to pop
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const FileUploadPage()),
                          );
                        },
                      ),
                      const Gap(8),
                      StyledFilledButton(
                        buttonText: 'Upload Multiple Files',
                        onPressed: () async {
                          var file = context.read<StorageManagerBloc>().state
                              as StorageManagerPickedFiles;
                          context.read<StorageManagerBloc>().add(
                                StorageManagerUploadMultiFromRawData(
                                  files: file.files,
                                ),
                              );

                          // Push FileUploadPage and wait for it to pop
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const FileUploadPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(8)
            ],
          ),
          const Gap(16),
        ],
      );
    }
    // Return an empty container for states that don't need a top row
    return Container();
  }

  Widget _buildContentBasedOnState(
      StorageManagerState state, BuildContext context) {
    if (state is StorageManagerInitial ||
        (state is StorageManagerPickedFiles && state.files.isEmpty)) {
      return EmptyListWidget(
        onPickFiles: () {
          context.read<StorageManagerBloc>().add(StorageManagerPickFiles());
        },
      );
    } else if (state is StorageManagerPickedFiles) {
      return ListView.builder(
        itemCount: state.files.length,
        itemBuilder: (context, index) {
          return FileCard(
            file: state.files[index],
            onDelete: () {
              context.read<StorageManagerBloc>().add(
                    StorageManagerRemoveFileFromUploadList(
                      file: state.files[index],
                    ),
                  );
            },
          );
        },
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
