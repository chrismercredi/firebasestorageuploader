import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../src.dart';

part 'firebase_bucket_manager_event.dart';
part 'firebase_bucket_manager_state.dart';

class FirebaseBucketManagerBloc
    extends Bloc<FirebaseBucketManagerEvent, FirebaseBucketManagerState> {
  final FirebaseStorageBucketRepository repository;
  FirebaseBucketManagerBloc({required this.repository})
      : super(FirebaseBucketManagerInitial()) {
    on<FetchFiles>(_onFetchFiles);
  }

  Future<void> _onFetchFiles(
      FetchFiles event, Emitter<FirebaseBucketManagerState> emit) async {
    emit(FirebaseBucketManagerLoading());
    try {
      // Fetch list of files from the repository
      var files = await repository.listAllFiles('path/to/directory');
      List<FileModel> fileModels = [];

      for (var file in files) {
        print('File: ${file.name}');
        // Fetch metadata for each file
        var metadata = await file.getMetadata();

        // Create a FileModel object with the required metadata
        var fileModel = FileModel(
          bucket: metadata.bucket,
          generation: metadata.generation,
          metageneration: metadata.metageneration.toString(),
          metadataGeneration: metadata.metadataGeneration.toString(),
          fullPath: metadata.fullPath,
          name: metadata.name,
          size: metadata.size,
          timeCreated: metadata.timeCreated,
          updated: metadata.updated,
          md5Hash: metadata.md5Hash,
        );

        // Add to the list
        fileModels.add(fileModel);
      }

      emit(FirebaseBucketManagerLoaded(fileModels));
    } catch (e) {
      emit(FirebaseBucketManagerError(e.toString()));
    }
  }
}
