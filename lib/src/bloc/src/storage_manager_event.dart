part of 'storage_manager_bloc.dart';

sealed class StorageManagerEvent extends Equatable {
  const StorageManagerEvent();

  @override
  List<Object> get props => [];
}

final class StorageManagerPickFiles extends StorageManagerEvent {}

final class StorageManagerUploadFromRawData extends StorageManagerEvent {
  final List<XFile> files;

  const StorageManagerUploadFromRawData({
    required this.files,
  });

  @override
  List<Object> get props => [files];
}

final class StorageManagerUploadSingleFromRawData extends StorageManagerEvent {
  final XFile file;

  const StorageManagerUploadSingleFromRawData({
    required this.file,
  });

  @override
  List<Object> get props => [file];
}

final class StorageManagerUploadMultiFromRawData extends StorageManagerEvent {
  final List<XFile> files;

  const StorageManagerUploadMultiFromRawData({
    required this.files,
  });

  @override
  List<Object> get props => [files];
}

final class StorageManagerClearPickedFiles extends StorageManagerEvent {}

final class StorageManagerRemoveFileFromUploadList extends StorageManagerEvent {
  final XFile file;

  const StorageManagerRemoveFileFromUploadList({
    required this.file,
  });

  @override
  List<Object> get props => [file];
}

final class RemoveUploadTask extends StorageManagerEvent {
  final UploadTaskInfo task;

  const RemoveUploadTask({
    required this.task,
  });

  @override
  List<Object> get props => [task];
}
