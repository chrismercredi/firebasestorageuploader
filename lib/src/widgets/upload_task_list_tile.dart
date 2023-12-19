import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasestoragemanager/src/src.dart';
import 'package:flutter/material.dart';

import '../l10n/uploader_localizations.dart';

/// A widget displaying the upload status of a file.
///
/// It shows the current state of the file being uploaded,
/// allows pausing, resuming, and canceling the upload,
/// and displays the upload progress.
class UploadTaskListTile extends StatelessWidget {
  /// The [UploadTask] associated with the file being uploaded.
  final UploadTask task;

  /// Creates an instance of [UploadTaskListTile].
  const UploadTaskListTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uploaderLocalizations = UploaderLocalizations.of(context);

    /// Formats the bytes transferred and total bytes into a readable string.
    String bytesTransferred(TaskSnapshot snapshot) {
      return '${snapshot.bytesTransferred.fileSize(context)}/'
          '${snapshot.totalBytes.fileSize(context)}';
    }

    return StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        String subtitle;
        if (snapshot.hasError) {
          subtitle = uploaderLocalizations.uploadError;
        } else if (snapshot.connectionState == ConnectionState.done) {
          subtitle = uploaderLocalizations.uploadComplete;
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          subtitle = uploaderLocalizations.waitingToUpload;
        } else {
          subtitle =
              '${uploaderLocalizations.uploading}: ${bytesTransferred(snapshot.data!)}';
        }

        String fileName = task.snapshot.ref.name;

        return ListTile(
          title: Text('${uploaderLocalizations.uploadingFile}: $fileName'),
          subtitle: Text(subtitle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (task.snapshot.state == TaskState.running)
                IconButton(
                  icon: const Icon(Icons.pause),
                  onPressed: task.pause,
                ),
              if (task.snapshot.state == TaskState.running)
                IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: task.cancel,
                ),
              if (task.snapshot.state == TaskState.paused)
                IconButton(
                  icon: const Icon(Icons.file_upload),
                  onPressed: task.resume,
                ),
              if (task.snapshot.state == TaskState.success)
                const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        );
      },
    );
  }
}
