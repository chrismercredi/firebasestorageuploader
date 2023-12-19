part of 'uploader_cubit.dart';

/// An abstract class representing the base state for the uploader.
abstract class UploaderState extends Equatable {
  /// Creates a new instance of [UploaderState].
  const UploaderState();

  @override
  List<Object?> get props => [];
}

/// The initial state of the uploader, representing no activity.
class UploaderInitial extends UploaderState {}

/// State representing that files have been selected for upload.
class UploaderFilesSelected extends UploaderState {
  /// The list of files that have been selected.
  final List<XFile> files;

  /// Creates a new instance of [UploaderFilesSelected] with the given [files].
  const UploaderFilesSelected(this.files);

  @override
  List<Object> get props => [files];
}

/// State representing that the upload tasks are in progress.
class UploaderTasksInProgress extends UploaderState {
  /// The list of ongoing upload tasks.
  final List<UploaderTaskInfo> tasks;

  /// Creates a new instance of [UploaderTasksInProgress] with the given [tasks].
  const UploaderTasksInProgress(this.tasks);

  @override
  List<Object> get props => [tasks];
}

/// State representing a snapshot of the ongoing upload tasks.
class UploaderTasksSnapshot extends UploaderState {
  /// The list of ongoing upload tasks with their current snapshot.
  final List<UploaderTaskInfo> tasks;

  /// Creates a new instance of [UploaderTasksSnapshot] with the given [tasks].
  const UploaderTasksSnapshot(this.tasks);

  @override
  List<Object> get props => [tasks];
}

/// State for displaying a snack bar message.
class SnackbarMessenger extends UploaderState {
  /// The message to be displayed in the snack bar.
  final String message;

  /// Creates a new instance of [SnackbarMessenger] with the given [message].
  const SnackbarMessenger(this.message);

  @override
  List<Object> get props => [message];
}

/// Exception related to the uploader.
class UploaderException implements Exception {
  /// The error message of the exception.
  final String message;

  /// Creates a new instance of [UploaderException] with the given [message].
  const UploaderException(this.message);
}

/// Exception thrown when an upload is cancelled.
class UploaderCancelledException extends UploaderException {
  /// Creates a new instance of [UploaderCancelledException].
  const UploaderCancelledException() : super('Cancelled');
}
