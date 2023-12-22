import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src.dart';

class UploadTaskPage extends StatelessWidget {
  const UploadTaskPage({super.key});

  Future<void> _downloadLink(Reference ref) async {
    final link = await ref.getDownloadURL();

    await Clipboard.setData(
      ClipboardData(
        text: link,
      ),
    );

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text(
    //       'Success!\n Copied download URL to Clipboard!',
    //     ),
    //   ),
    // );
  }

  Future<void> _delete(Reference ref) async {
    await ref.delete();

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //         'Success!\n deleted ${ref.name} \n from bucket: ${ref.bucket}\n '
    //         'at path: ${ref.fullPath} \n'),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Tasks'),
      ),
      body: BlocBuilder<StorageManagerBloc, StorageManagerState>(
        builder: (context, state) {
          if (state is StorageManagerInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UploadTasks) {
            final tasks = state.uploadTasks;

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks;

                return UploadTaskListTile(
                    task: task[index],
                    onDismissed: () {},
                    onDownload: () {},
                    onDownloadLink: () async {
                      return _downloadLink(task[index].snapshot.ref);
                    },
                    onDelete: () {});
              },
            );
          } else {
            // Handle other states or show an error
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
