import 'dart:io' as io;
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_selector/file_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasestoragemanager/src/cubit/uploader_cubit.dart';
import 'package:mime/mime.dart';

part 'firebase_storage_manager_event.dart';
part 'firebase_storage_manager_state.dart';

class FirebaseStorageManagerBloc
    extends Bloc<FirebaseStorageManagerEvent, FirebaseStorageManagerState> {
  final XTypeGroup typeGroup;
  // ignore: prefer_final_fields
  List<UploaderTaskInfo> _uploadTasks = [];
  // ignore: prefer_final_fields
  List<XFile> _selectedFiles = [];

  FirebaseStorageManagerBloc({required this.typeGroup})
      : super(FirebaseStorageManagerInitial()) {
    on<FirebaseStorageManagerSelectFiles>(_onSelectFiles);
    on<FirebaseStorageManagerStartUpload>(_onStartUpload);
    on<FirebaseStorageManagerRemoveSelectedFile>(_onRemoveSelectedFile);
    on<FirebaseStorageManagerClearSelectedFiles>(_onClearSelectedFiles);
    on<FirebaseStorageClearAllTasks>(_onClearAllTasks);
  }

  // Handler for clearing the selected files list
  void _onClearSelectedFiles(
    FirebaseStorageManagerClearSelectedFiles event,
    Emitter<FirebaseStorageManagerState> emit,
  ) {
    _selectedFiles.clear();
    emit(FirebaseStorageManagerInitial());
  }

  // Handler for removing a single selected file
  void _onRemoveSelectedFile(
    FirebaseStorageManagerRemoveSelectedFile event,
    Emitter<FirebaseStorageManagerState> emit,
  ) {
    _selectedFiles = List.from(_selectedFiles)..remove(event.file);
    if (_selectedFiles.isEmpty) {
      emit(FirebaseStorageManagerInitial());
    } else {
      emit(FirebaseStorageManagerFilesSelected(_selectedFiles));
    }
  }

  Future<void> _onClearAllTasks(
    FirebaseStorageClearAllTasks event,
    Emitter<FirebaseStorageManagerState> emit,
  ) async {
    for (var task in _uploadTasks) {
      await task.snapshot?.ref.delete();
    }
    _uploadTasks.clear();
    emit(FirebaseStorageManagerInitial());
  }

  Future<void> _onSelectFiles(
    FirebaseStorageManagerSelectFiles event,
    Emitter<FirebaseStorageManagerState> emit,
  ) async {
    try {
      final newFiles = await openFiles(acceptedTypeGroups: [typeGroup]);

      // Combine old and new files, ensuring uniqueness by file path
      final allFiles = {..._selectedFiles, ...newFiles}.toList();

      // Update the selected files list
      _selectedFiles = allFiles;

      // Emit the state with the updated list of files
      emit(FirebaseStorageManagerFilesSelected(_selectedFiles));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onStartUpload(
    FirebaseStorageManagerStartUpload event,
    Emitter<FirebaseStorageManagerState> emit,
  ) async {
    await uploadFile(event.files, event.isWeb, event.user);
  }

  /// Uploads a list of [files].
  ///
  /// It takes [isWeb] to determine the platform, and [user] to define the user.
  Future<void> uploadFile(List<XFile?> files, bool isWeb, User user) async {
    if (files.isEmpty) {
      emit(const FirebaseStorageManagerSnackbarMessenger('No files selected'));
      return;
    }

    String uid = user.uid;

    for (var file in files) {
      if (file == null) continue;

      UploadTask uploadTask;

      Reference ref = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(uid)
          .child('uploads')
          .child(file.name);

      String? mimeType;

      if (isWeb) {
        final data = await file.readAsBytes();
        mimeType = lookupMimeType(file.path,
            headerBytes: data.sublist(0, math.min(12, data.length)));
        uploadTask = ref.putData(data, SettableMetadata(contentType: mimeType));
      } else {
        final io.File localFile = io.File(file.path);
        mimeType = lookupMimeType(file.path,
            headerBytes: await localFile.openRead().first);
        uploadTask =
            ref.putFile(localFile, SettableMetadata(contentType: mimeType));
      }

      var uploaderTaskInfo = UploaderTaskInfo(uploadTask, null);
      _uploadTasks.add(uploaderTaskInfo);

      // Emit a state to represent the ongoing upload.
      emit(FirebaseStorageManagerTasksInProgress(List.from(_uploadTasks)));

      // Listen to the upload task’s progress.
      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          uploaderTaskInfo.snapshot = snapshot;
          // Emit a state with the updated snapshot.
          emit(FirebaseStorageManagerTasksSnapshot(List.from(_uploadTasks)));
        },
        onError: (e) {
          // Handle any errors that occur during the upload.
          emit(FirebaseStorageManagerSnackbarMessenger('Upload failed: $e'));
        },
        onDone: () async {
          // Wait for the upload to complete
          await uploadTask;
          // Handle completion of the upload.
          emit(const FirebaseStorageManagerSnackbarMessenger(
              'Upload complete!'));
          // Optionally, you can also remove the completed task from the list
          _uploadTasks.remove(uploaderTaskInfo);
          if (_uploadTasks.isEmpty) {
            emit(FirebaseStorageManagerInitial());
          } else {
            emit(FirebaseStorageManagerTasksSnapshot(List.from(_uploadTasks)));
          }
        },
      );
    }
  }
}
