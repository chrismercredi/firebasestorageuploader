import 'dart:io' as io;
import 'dart:math' as math;

import 'package:file_selector/file_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

/// A repository for managing file uploads to Firebase Storage.
///
/// This class provides methods to upload files to Firebase Storage,
/// abstracting the details of file upload away from the UI/business logic.
class FilesRepository {
  /// The instance of Firebase Storage.
  ///
  /// This is used to interact with Firebase Storage for file operations.
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage.
  ///
  /// This method takes a [XFile] object, a boolean [isWeb] indicating if the
  /// platform is web, and a [User] object for the user performing the upload.
  /// It returns an [UploadTask] which can be used to track the upload progress.
  ///
  /// Throws an [Exception] if the file is null.
  ///
  /// Example:
  /// ```dart
  /// var repository = FilesRepository();
  /// var uploadTask = repository.uploadFile(file, isWeb, user);
  /// ```
  Future<UploadTask> uploadFile(XFile file, bool isWeb, User user) async {
    String uid = user.uid;
    Reference ref = _storage
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
      return ref.putData(data, SettableMetadata(contentType: mimeType));
    } else {
      final io.File localFile = io.File(file.path);
      mimeType = lookupMimeType(file.path,
          headerBytes: await localFile.openRead().first);
      return ref.putFile(localFile, SettableMetadata(contentType: mimeType));
    }
  }
}
