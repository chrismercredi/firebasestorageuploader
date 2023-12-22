import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

class StorageManagerRepository {
  FirebaseStorage firebaseStorage;

  StorageManagerRepository({required this.firebaseStorage});

  /// A constant defining the types of files that can be selected.
  ///
  /// This configuration specifies a list of file extensions that are allowed
  /// to be picked by the file selector. It includes common formats like images,
  /// documents, spreadsheets, presentations, and text files.
  static const XTypeGroup typeGroup = XTypeGroup(
    label: 'Files',
    extensions: <String>[
      'jpg', 'jpeg', 'png', // Images
      'doc', 'docx', // Word documents
      'xls', 'xlsx', // Excel spreadsheets
      'ppt', 'pptx', // PowerPoint presentations
      'pdf', // PDFs
      'svg', // SVGs
      'txt', 'rtf', // Text and Rich Text Format
      'mp4'
    ],
  );

  Future<List<XFile>> pickFiles() async {
    final result = await openFiles(acceptedTypeGroups: [typeGroup]);
    return result.isNotEmpty ? result : [];
  }

  Future<List<UploadTask>> uploadFiles(List<XFile> files, String uid) async {
    List<UploadTask> uploadTasks = [];
    for (XFile file in files) {
      final mimeType = lookupMimeType(file.name);
      if (mimeType == null) {
        throw Exception("Unable to determine MIME type of the file");
      }

      final metadata = SettableMetadata(
          contentType: mimeType,
          customMetadata: {'picked-file-path': file.path});
      final storagePath = 'users/$uid/uploads/${file.name}';
      final storageRef = firebaseStorage.ref();
      final fileData = await file.readAsBytes();

      UploadTask uploadTask =
          storageRef.child(storagePath).putData(fileData, metadata);
      uploadTasks.add(uploadTask);
    }
    return uploadTasks;
  }
}
