import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasestoragemanager/src/src.dart';
import 'package:flutter/material.dart';

/// A widget displaying the upload status of a file.
///
/// This widget is responsible for showing the current state of a file upload.
/// It allows users to interact with the upload process by pausing, resuming,
/// or canceling it. It also visually displays the upload's progress.
///
/// The widget uses a `StreamBuilder` to listen to `snapshotEvents` from
/// the `UploadTask`. This ensures the UI updates in real-time as the upload
/// progresses or changes state.
///
/// Example Usage:
/// ```dart
/// UploadTaskListTile(task: myUploadTask);
/// ```
class UploadTaskListTile extends StatelessWidget {
  /// The [UploadTask] associated with the file being uploaded.
  final UploadTask task;

  /// Creates an instance of [UploadTaskListTile].
  ///
  /// Requires an [UploadTask] which represents the ongoing file upload task.
  const UploadTaskListTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uploaderLocalizations = UploaderLocalizations.of(context);

    /// Formats the bytes transferred and total bytes into a readable string.
    ///
    /// This function takes in a [TaskSnapshot] and returns a formatted string
    /// representing the amount of data transferred over the total size of the file.
    String bytesTransferred(TaskSnapshot snapshot) {
      return '${snapshot.bytesTransferred.fileSize(context)}/'
          '${snapshot.totalBytes.fileSize(context)}';
    }

    return StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        String subtitle;

        // Check for various states of the upload task
        //and update the subtitle accordingly
        if (snapshot.hasError) {
          // Display an error message if the upload task encounters an error
          subtitle = uploaderLocalizations.uploadError;
        } else if (snapshot.connectionState == ConnectionState.done ||
            snapshot.data?.bytesTransferred == snapshot.data?.totalBytes) {
          // If the upload is complete or the uploaded bytes equal the total bytes,
          //show a 'complete' message
          subtitle = uploaderLocalizations.uploadComplete;
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          // If waiting to start, show a 'waiting' message
          subtitle = uploaderLocalizations.waitingToUpload;
        } else {
          // Otherwise, display an 'uploading' message with the amount of data transferred
          subtitle =
              '${uploaderLocalizations.uploading}: ${bytesTransferred(snapshot.data!)}';
        }

        // Get the file name from the upload task
        String fileName = task.snapshot.ref.name;

        // Build a ListTile widget to display the file name and upload status
        return ListTile(
          title: Text(fileName),
          subtitle: Text(subtitle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Display different icons based on the upload task's state
              if (task.snapshot.state == TaskState.running)
                IconButton(
                  icon: const Icon(Icons.pause),
                  onPressed: task
                      .pause, // Pause the upload task when this button is pressed
                ),
              if (task.snapshot.state == TaskState.running)
                IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: task
                      .cancel, // Cancel the upload task when this button is pressed
                ),
              if (task.snapshot.state == TaskState.paused)
                IconButton(
                  icon: const Icon(Icons.file_upload),
                  onPressed: task
                      .resume, // Resume the upload task when this button is pressed
                ),
              if (task.snapshot.state == TaskState.success)
                const Icon(Icons.check_circle,
                    color: Colors
                        .green), // Show a success icon if the upload is complete
            ],
          ),
        );
      },
    );
  }
}
