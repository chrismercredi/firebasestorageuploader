part of 'firebase_storage_manager_bloc.dart';

sealed class FirebaseStorageManagerEvent extends Equatable {
  const FirebaseStorageManagerEvent();

  @override
  List<Object> get props => [];
}

final class FirebaseStorageManagerSelectFiles
    extends FirebaseStorageManagerEvent {}

final class FirebaseStorageManagerClearSelectedFiles
    extends FirebaseStorageManagerEvent {}

final class FirebaseStorageManagerUploadFiles
    extends FirebaseStorageManagerEvent {
  final List<XFile> files;
  final bool isWeb;
  final User user;

  const FirebaseStorageManagerUploadFiles({
    required this.files,
    required this.isWeb,
    required this.user,
  });

  @override
  List<Object> get props => [files, isWeb, user];
}

// Event to remove a single selected file
class FirebaseStorageManagerRemoveSelectedFile
    extends FirebaseStorageManagerEvent {
  final XFile file;

  const FirebaseStorageManagerRemoveSelectedFile(this.file);

  @override
  List<Object> get props => [file];
}

final class FirebaseStorageManagerStartUpload
    extends FirebaseStorageManagerEvent {
  final List<XFile> files;
  final bool isWeb;
  final User user;

  const FirebaseStorageManagerStartUpload({
    required this.files,
    required this.isWeb,
    required this.user,
  });

  @override
  List<Object> get props => [files, isWeb, user];
}

final class FirebaseStorageClearAllTasks extends FirebaseStorageManagerEvent {}
