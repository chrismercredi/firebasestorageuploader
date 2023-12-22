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

  final List<UploadTaskInfo> _uploadTasks = [];

  StorageManagerBloc({
    required this.storageManagerRepository,
  }) : super(
          StorageManagerInitial(),
        ) {
    on<StorageManagerPickFiles>(_onStorageManagerPickFiles);
    on<StorageManagerUploadSingleFromRawData>(_onUploadSingleFromRawData);
    on<StorageManagerClearPickedFiles>(_onClearPickedFiles);
    on<StorageManagerRemoveFileFromUploadList>(
        _onStorageManagerRemoveFileFromUploadList);
    on<StorageManagerUploadMultiFromRawData>(_onUploadMultiFromRawData);
    on<RemoveUploadTask>(_onRemoveUploadTask);
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
          StorageManagerUploadTasks(
            tasks: List.from(_uploadTasks),
          ),
        );
      }
    }
  }

  void _onStorageManagerPickFiles(
    StorageManagerPickFiles event,
    Emitter<StorageManagerState> emit,
  ) async {
    var files = await storageManagerRepository.pickFiles();
    emit(
      StorageManagerPickedFiles(
        files: files,
      ),
    );
  }

  void _onStorageManagerRemoveFileFromUploadList(
    StorageManagerRemoveFileFromUploadList event,
    Emitter<StorageManagerState> emit,
  ) async {
    final files = state as StorageManagerPickedFiles;
    final newFiles =
        files.files.where((file) => file.path != event.file.path).toList();
    if (newFiles.isEmpty) {
      emit(
        StorageManagerInitial(),
      );
      return;
    }
    emit(
      StorageManagerPickedFiles(
        files: newFiles,
      ),
    );
  }

  void _onClearPickedFiles(
    StorageManagerClearPickedFiles event,
    Emitter<StorageManagerState> emit,
  ) async {
    emit(
      StorageManagerInitial(),
    );
  }

  void _onUploadSingleFromRawData(
    StorageManagerUploadSingleFromRawData event,
    Emitter<StorageManagerState> emit,
  ) async {
    try {
      final firebaseStorage = FirebaseStorage.instance;
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      // Get the file's MimeType
      final mimeType = lookupMimeType(event.file.name);

      // If the MimeType is null, throw an exception
      if (mimeType == null) {
        throw Exception("Unable to determine MIME type of the file");
      }

      // Create the file metadata
      final metadata = SettableMetadata(
        contentType: mimeType,
        customMetadata: {
          'picked-file-path': event.file.path,
        },
      );

      // Build the storage path
      final storagePath = 'users/$uid/uploads/${event.file.name}';

      // Get the storage reference
      final storageRef = firebaseStorage.ref();

      // Read the file as bytes
      final fileData = await event.file.readAsBytes();

      UploadTask uploadTask =
          storageRef.child(storagePath).putData(fileData, metadata);

      var uploadTaskInfo = UploadTaskInfo(
        task: uploadTask,
        snapshot: null,
      );

      emit(
        StorageManagerUploadTasks(
          tasks: [uploadTaskInfo],
        ),
      );
      // Listen to snapshot events
      await for (TaskSnapshot snapshot in uploadTask.snapshotEvents) {
        uploadTaskInfo.snapshot = snapshot;

        if (snapshot.state == TaskState.success ||
            snapshot.state == TaskState.error) {
          // Break the loop when upload is successful or failed
          break;
        }

        if (!emit.isDone) {
          emit(
            StorageManagerUploadTasks(
              tasks: [uploadTaskInfo],
            ),
          );
        }
      }

      // After completion or failure of the upload
      if (!emit.isDone) {
        if (uploadTaskInfo.snapshot?.state == TaskState.success) {
          // Get the download URL
          String downloadUrl =
              await storageRef.child(storagePath).getDownloadURL();
          emit(
            StorageManagerUploadTaskComplete(
              taskInfo: uploadTaskInfo,
            ),
          );
          emit(
            StorageManagerUploadSuccess(
              downloadUrl: downloadUrl,
            ),
          );
          emit(
            StorageManagerInitial(),
          );
        } else if (uploadTaskInfo.snapshot?.state == TaskState.error) {
          emit(
            const StorageManagerUploadTaskError(
                message: 'Error uploading file'),
          );
        }
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(
          const StorageManagerUploadTaskError(message: 'Error uploading file'),
        );
      }
    }
  }

  void _onUploadMultiFromRawData(
    StorageManagerUploadMultiFromRawData event,
    Emitter<StorageManagerState> emit,
  ) async {
    final firebaseStorage = FirebaseStorage.instance;
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    for (XFile file in event.files) {
      try {
        // Get the file's MimeType
        final mimeType = lookupMimeType(file.name);

        if (mimeType == null) {
          throw Exception("Unable to determine MIME type of the file");
        }

        // Create file metadata
        final metadata = SettableMetadata(
          contentType: mimeType,
          customMetadata: {
            'picked-file-path': file.path,
          },
        );

        // Build the storage path
        final storagePath = 'users/$uid/uploads/${file.name}';

        // Get the storage reference
        final storageRef = firebaseStorage.ref();

        // Read the file as bytes
        final fileData = await file.readAsBytes();

        var uploadTask =
            storageRef.child(storagePath).putData(fileData, metadata);

        var uploadTaskInfo = UploadTaskInfo(
          task: uploadTask,
          snapshot: null,
        );

        _uploadTasks.add(uploadTaskInfo);

        emit(
          StorageManagerUploadTasks(
            tasks: List.from(_uploadTasks),
          ),
        );

        // Listen to snapshot events
        uploadTask.snapshotEvents.listen(
          (TaskSnapshot snapshot) {
            uploadTaskInfo.snapshot = snapshot;
            if (!emit.isDone) {
              // Emit the updated list of upload tasks
              emit(
                StorageManagerUploadTasks(
                  tasks: List.from(_uploadTasks),
                ),
              );
            }
          },
          onError: (Object e) {},
          onDone: () async {
            await uploadTask;
            _uploadTasks.remove(uploadTaskInfo);

            if (!emit.isDone) {
              if (_uploadTasks.isEmpty) {
                emit(
                  StorageManagerInitial(),
                );
              } else {
                emit(
                  StorageManagerUploadTasks(
                    tasks: List.from(_uploadTasks),
                  ),
                );
              }
            }
          },
        );
      } catch (e) {
        if (!emit.isDone) {
          emit(
            const StorageManagerUploadTaskError(
                message: 'Error uploading file'),
          );
        }
      }
    }
  }
}
