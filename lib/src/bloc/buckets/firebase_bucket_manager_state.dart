part of 'firebase_bucket_manager_bloc.dart';

sealed class FirebaseBucketManagerState extends Equatable {
  const FirebaseBucketManagerState();

  @override
  List<Object> get props => [];
}

final class FirebaseBucketManagerInitial extends FirebaseBucketManagerState {}

final class FirebaseBucketManagerLoading extends FirebaseBucketManagerState {}

final class FirebaseBucketManagerLoaded extends FirebaseBucketManagerState {
  final List<FileModel> files;

  const FirebaseBucketManagerLoaded(this.files);

  @override
  List<Object> get props => [files];
}

final class FirebaseBucketManagerError extends FirebaseBucketManagerState {
  final String message;

  const FirebaseBucketManagerError(this.message);

  @override
  List<Object> get props => [message];
}
