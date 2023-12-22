part of 'storage_manager_bloc.dart';

sealed class StorageManagerEvent extends Equatable {
  const StorageManagerEvent();

  @override
  List<Object> get props => [];
}

final class PickFiles extends StorageManagerEvent {}

final class ClearPickedFiles extends StorageManagerEvent {}

final class RemoveFileFromUploadList extends StorageManagerEvent {
  final XFile file;

  const RemoveFileFromUploadList({
    required this.file,
  });

  @override
  List<Object> get props => [file];
}

final class RemoveUploadTask extends StorageManagerEvent {
  final UploadTask task;

  const RemoveUploadTask({
    required this.task,
  });

  @override
  List<Object> get props => [task];
}

final class UploadFromRawData extends StorageManagerEvent {
  final List<XFile> files;

  const UploadFromRawData({
    required this.files,
  });

  @override
  List<Object> get props => [files];
}
