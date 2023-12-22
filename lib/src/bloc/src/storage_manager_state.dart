part of 'storage_manager_bloc.dart';

sealed class StorageManagerState extends Equatable {
  const StorageManagerState();

  @override
  List<Object> get props => [];
}

// No files have been picked yet
final class StorageManagerInitial extends StorageManagerState {}

// Files have been picked
final class StorageManagerHasPickedFiles extends StorageManagerState {
  final List<XFile> files;

  const StorageManagerHasPickedFiles({required this.files});

  @override
  List<Object> get props => [files];
}

final class UploadTaskError extends StorageManagerState {
  final String message;

  const UploadTaskError({required this.message});

  @override
  List<Object> get props => [message];
}

final class UploadTasks extends StorageManagerState {
  final List<UploadTask> uploadTasks;

  const UploadTasks({required this.uploadTasks});

  @override
  List<Object> get props => [uploadTasks];
}
