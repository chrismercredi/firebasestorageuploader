part of 'storage_manager_bloc.dart';

sealed class StorageManagerState extends Equatable {
  const StorageManagerState();

  @override
  List<Object> get props => [];
}

// No files have been picked yet
final class StorageManagerInitial extends StorageManagerState {}

// Files have been picked
final class StorageManagerPickedFiles extends StorageManagerState {
  final List<XFile> files;

  const StorageManagerPickedFiles({
    required this.files,
  });

  @override
  List<Object> get props => [files];
}

final class StorageManagerUploadTasks extends StorageManagerState {
  final List<UploadTaskInfo> tasks;

  const StorageManagerUploadTasks({
    required this.tasks,
  });

  @override
  List<Object> get props => [tasks];
}

final class StorageManagerUploadTaskPaused extends StorageManagerState {
  final UploadTaskInfo taskInfo;

  const StorageManagerUploadTaskPaused({
    required this.taskInfo,
  });

  @override
  List<Object> get props => [taskInfo];
}

final class StorageManagerUploadTaskResumed extends StorageManagerState {
  final UploadTaskInfo taskInfo;

  const StorageManagerUploadTaskResumed({
    required this.taskInfo,
  });

  @override
  List<Object> get props => [taskInfo];
}

final class StorageManagerUploadTaskComplete extends StorageManagerState {
  final UploadTaskInfo taskInfo;

  const StorageManagerUploadTaskComplete({
    required this.taskInfo,
  });

  @override
  List<Object> get props => [taskInfo];
}

final class StorageManagerUploadTaskError extends StorageManagerState {
  final String message;

  const StorageManagerUploadTaskError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

// File uploading has been completed
final class StorageManagerUploadSuccess extends StorageManagerState {
  final String downloadUrl;

  const StorageManagerUploadSuccess({
    required this.downloadUrl,
  });

  @override
  List<Object> get props => [downloadUrl];
}
