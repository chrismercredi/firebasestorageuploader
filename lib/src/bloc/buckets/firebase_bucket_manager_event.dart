part of 'firebase_bucket_manager_bloc.dart';

sealed class FirebaseBucketManagerEvent extends Equatable {
  const FirebaseBucketManagerEvent();

  @override
  List<Object> get props => [];
}

class FetchFiles extends FirebaseBucketManagerEvent {
  const FetchFiles();
}
