import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src.dart';

/// A widget that displays a list of selected files.
class SelectedFilesList extends StatelessWidget {
  const SelectedFilesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirebaseStorageManagerBloc, FirebaseStorageManagerState>(
      builder: (context, state) {
        if (state is FirebaseStorageManagerFilesSelected) {
          return Expanded(
            child: ListView(
              children: state.files
                  .map((file) => SelectedFileListTile(file: file))
                  .toList(),
            ),
          );
        } else {
          // Return an empty container or a placeholder if no files are selected
          return Container();
        }
      },
    );
  }
}
