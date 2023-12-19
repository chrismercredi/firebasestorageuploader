import 'package:firebase_storage/firebase_storage.dart';

/// `UploaderTaskInfo` holds information about an upload task.
class UploadingTaskInfo {
  /// The `UploadTask` associated with this upload.
  final UploadingTaskInfo task;

  /// The `TaskSnapshot` associated with this upload, can be null.
  TaskSnapshot? snapshot;

  /// Creates a new instance of `UploaderTaskInfo`.
  UploadingTaskInfo(this.task, this.snapshot);
}
