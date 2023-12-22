import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../src.dart';

class UploadTaskPage extends StatelessWidget {
  final Stream<List<UploadTask>> uploadTasksStream;

  const UploadTaskPage({
    Key? key,
    required this.uploadTasksStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Tasks"),
      ),
      body: StreamBuilder<List<UploadTask>>(
        stream: uploadTasksStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No active upload tasks."));
          }

          List<UploadTask> tasks = snapshot.data!;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return UploadTaskListTile(task: tasks[index]);
            },
          );
        },
      ),
    );
  }

  void _handleDelete(UploadTask task) {
    // Implement logic to handle the deletion of an upload task
    // This might involve cancelling the task and removing it from the list
  }
}
