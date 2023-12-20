import 'package:firebase_storage/firebase_storage.dart';

/// `UploaderTaskInfo` holds information about an upload task.
class UploaderTaskInfo {
  /// The `UploadTask` associated with this upload.
  final UploadTask task;

  /// The `TaskSnapshot` associated with this upload, can be null.
  TaskSnapshot? snapshot;

  /// Creates a new instance of `UploaderTaskInfo`.
  UploaderTaskInfo(this.task, this.snapshot);
}
