part of 'firebase_storage_manager_bloc.dart';

sealed class FirebaseStorageManagerState extends Equatable {
  const FirebaseStorageManagerState();

  @override
  List<Object> get props => [];
}

final class FirebaseStorageManagerInitial extends FirebaseStorageManagerState {}

final class FirebaseStorageManagerFilesSelected
    extends FirebaseStorageManagerState {
  final List<XFile> files;

  const FirebaseStorageManagerFilesSelected(this.files);

  @override
  List<Object> get props => [files];
}

final class FirebaseStorageManagerTasksInProgress
    extends FirebaseStorageManagerState {
  final List<UploaderTaskInfo> tasks;

  const FirebaseStorageManagerTasksInProgress(this.tasks);

  @override
  List<Object> get props => [tasks];
}

final class FirebaseStorageManagerTasksSnapshot
    extends FirebaseStorageManagerState {
  final List<UploaderTaskInfo> tasks;

  const FirebaseStorageManagerTasksSnapshot(this.tasks);

  @override
  List<Object> get props => [tasks];
}

final class FirebaseStorageManagerSnackbarMessenger
    extends FirebaseStorageManagerState {
  final String message;

  const FirebaseStorageManagerSnackbarMessenger(this.message);

  @override
  List<Object> get props => [message];
}

final class FirebaseStorageManagerSnackbarDismissed
    extends FirebaseStorageManagerState {}

final class FirebaseStorageManagerException implements Exception {
  final String message;

  const FirebaseStorageManagerException(this.message);

  @override
  String toString() => message;
}

final class FirebaseStorageCancelledException
    extends FirebaseStorageManagerException {
  const FirebaseStorageCancelledException()
      : super('The upload was cancelled.');
}
