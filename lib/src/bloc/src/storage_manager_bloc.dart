import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_selector/file_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

import '../../src.dart';

part 'storage_manager_event.dart';
part 'storage_manager_state.dart';

class StorageManagerBloc
    extends Bloc<StorageManagerEvent, StorageManagerState> {
  StorageManagerRepository storageManagerRepository;

  // ignore: prefer_final_fields
  List<UploadTask> _uploadTasks = [];

  StorageManagerBloc({
    required this.storageManagerRepository,
  }) : super(
          StorageManagerInitial(),
        ) {
    on<PickFiles>(_onStorageManagerPickFiles);
    on<ClearPickedFiles>(_onClearPickedFiles);
    on<RemoveFileFromUploadList>(_onStorageManagerRemoveFileFromUploadList);
    on<RemoveUploadTask>(_onRemoveUploadTask);
    on<UploadFromRawData>(_onUploadFromRawData);
  }

  void _onUploadFromRawData(
    UploadFromRawData event,
    Emitter<StorageManagerState> emit,
  ) async {
    final firebaseStorage = FirebaseStorage.instance;
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    for (XFile file in event.files) {
      try {
        // Get the file's MimeType
        final mimeType = lookupMimeType(file.name);

        // If the MimeType is null, throw an exception
        if (mimeType == null) {
          throw Exception("Unable to determine MIME type of the file");
        }

        // Create the file metadata
        final metadata = SettableMetadata(
          contentType: mimeType,
          customMetadata: {
            'picked-file-path': file.path,
          },
        );

        UploadTask uploadTask;

        // Build the storage path
        final storagePath = 'users/$uid/uploads/${file.name}';

        // Get the storage reference
        final storageRef = firebaseStorage.ref();

        // Read the file as bytes
        final fileData = await file.readAsBytes();

        uploadTask = storageRef.child(storagePath).putData(fileData, metadata);

        _uploadTasks.add(uploadTask);
      } catch (e) {
        if (!emit.isDone) {
          emit(
            const UploadTaskError(message: 'Error uploading file'),
          );
        }
      }
    }
    emit(UploadTasks(uploadTasks: _uploadTasks));
  }

  void _onRemoveUploadTask(
    RemoveUploadTask event,
    Emitter<StorageManagerState> emit,
  ) async {
    _uploadTasks.remove(event.task);
    if (!emit.isDone) {
      if (_uploadTasks.isEmpty) {
        emit(
          StorageManagerInitial(),
        );
      } else {
        emit(
          UploadTasks(
            uploadTasks: List.from(_uploadTasks),
          ),
        );
      }
    }
  }

  void _onStorageManagerPickFiles(
    PickFiles event,
    Emitter<StorageManagerState> emit,
  ) async {
    var files = await storageManagerRepository.pickFiles();
    emit(
      StorageManagerHasPickedFiles(
        files: files,
      ),
    );
  }

  void _onStorageManagerRemoveFileFromUploadList(
    RemoveFileFromUploadList event,
    Emitter<StorageManagerState> emit,
  ) async {
    final files = state as StorageManagerHasPickedFiles;
    final newFiles =
        files.files.where((file) => file.path != event.file.path).toList();
    if (newFiles.isEmpty) {
      emit(
        StorageManagerInitial(),
      );
      return;
    }
    emit(
      StorageManagerHasPickedFiles(
        files: newFiles,
      ),
    );
  }

  void _onClearPickedFiles(
    ClearPickedFiles event,
    Emitter<StorageManagerState> emit,
  ) async {
    emit(
      StorageManagerInitial(),
    );
  }
}
