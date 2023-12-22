import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasestoragemanager/src/widgets/uploads_complete_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src.dart';

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({Key? key}) : super(key: key);

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Uploads'),
      ),
      body: BlocBuilder<StorageManagerBloc, StorageManagerState>(
        builder: (context, state) {
          if (state is StorageManagerUploadTasks) {
            if (state.tasks.isEmpty) {
              return UploadsCompleteWidget(onPickFiles: () {});
            }
            return _buildUploadTaskList(state.tasks);
          }
          return UploadsCompleteWidget(onPickFiles: () {});
        },
      ),
    );
  }

  Widget _buildUploadTaskList(List<UploadTaskInfo> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final taskInfo = tasks[index];
        return Card(
          child: ListTile(
            title: Text(
                taskInfo.task.snapshot.ref.name), // Example, modify as needed
            subtitle: StreamBuilder<TaskSnapshot>(
              stream: taskInfo.task.snapshotEvents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Starting upload...');
                } else if (snapshot.hasData) {
                  final progress = snapshot.data!.bytesTransferred /
                      snapshot.data!.totalBytes;
                  if (progress == 1.0) {
                    context.read<StorageManagerBloc>().add(
                          RemoveUploadTask(task: taskInfo),
                        );
                  }
                  return LinearProgressIndicator(value: progress);
                } else if (snapshot.hasError) {
                  return const Text('Error during upload');
                }
                return const Text('Upload complete');
              },
            ),
            trailing: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                taskInfo.task.cancel(); // Implement cancellation functionality
              },
            ),
          ),
        );
      },
    );
  }
}
