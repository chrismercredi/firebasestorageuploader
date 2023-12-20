import 'dart:io' as io;
import 'dart:math' as math;

import 'package:file_selector/file_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

import '../../src.dart';

/// A repository for managing file uploads to Firebase Storage.
class FirebaseStorageUploaderRepository {
  final FirebaseStorage _storage;

  FirebaseStorageUploaderRepository({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  /// Initiates a file upload and returns `UploaderTaskInfo` for tracking.
  Future<UploaderTaskInfo> uploadFile(XFile file, bool isWeb, User user) async {
    try {
      final uploadData = await _prepareUploadData(file, isWeb);
      final uploadTask = _startUploadTask(uploadData, user, file.name);
      return UploaderTaskInfo(uploadTask, null);
    } catch (e) {
      throw UploadException('Failed to upload file: ${file.name}', e);
    }
  }

  /// Watches the upload task for progress updates.
  Stream<UploaderTaskInfo> watchUploadTask(
      UploaderTaskInfo uploaderTaskInfo) async* {
    final task = uploaderTaskInfo.task;
    yield* task.snapshotEvents.map((snapshot) {
      return UploaderTaskInfo(task, snapshot);
    });
  }

  Future<UploadData> _prepareUploadData(XFile file, bool isWeb) async {
    String? mimeType;
    dynamic data;

    if (isWeb) {
      data = await file.readAsBytes();
      mimeType = _getMimeType(file.path, data);
    } else {
      final io.File localFile = io.File(file.path);
      mimeType = _getMimeType(file.path, await localFile.openRead().first);
      data = localFile;
    }

    return UploadData(data, mimeType);
  }

  UploadTask _startUploadTask(
      UploadData uploadData, User user, String fileName) {
    final ref = _storage
        .ref()
        .child('users')
        .child(user.uid)
        .child('uploads')
        .child(fileName);

    return uploadData.data is io.File
        ? ref.putFile(
            uploadData.data, SettableMetadata(contentType: uploadData.mimeType))
        : ref.putData(uploadData.data,
            SettableMetadata(contentType: uploadData.mimeType));
  }

  String _getMimeType(String path, List<int> headerBytes) {
    return lookupMimeType(path,
            headerBytes:
                headerBytes.sublist(0, math.min(12, headerBytes.length))) ??
        'application/octet-stream'; // default MIME type
  }
}
