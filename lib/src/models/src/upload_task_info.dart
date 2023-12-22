import 'package:firebase_storage/firebase_storage.dart';

/// A class that contains information about an [UploadTask].
///
/// This class is used in scenarios where you need to keep track of the
/// [UploadTask] and its associated [TaskSnapshot].
class UploadTaskInfo {
  /// The [UploadTask] associated with this info.
  final UploadTask task;

  /// The [TaskSnapshot] associated with this info.
  TaskSnapshot? snapshot;

  /// Constructs a [UploadTaskInfo] with the given [task] and [snapshot].
  UploadTaskInfo({
    required this.task,
    this.snapshot,
  });
}
