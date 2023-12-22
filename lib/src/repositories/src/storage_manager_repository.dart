import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

/// Exception thrown when no files are picked during file selection.
///
/// This exception is used in scenarios where file selection is mandatory and
/// the user fails to pick any files.
///
/// Example:
/// ```dart
/// try {
///   final files = await repository.pickFiles();
///   // Proceed with files
/// } catch (e) {
///   if (e is PickFilesException) {
///     // Handle the scenario where no files are picked
///   }
/// }
/// ```
class PickFilesException implements Exception {
  /// The message describing the exception.
  final String message;

  /// Constructs a [PickFilesException] with the given [message].
  PickFilesException(this.message);

  @override
  String toString() => 'PickFilesException: $message';
}

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

  /// Opens a file selector to pick files and returns a list of `XFile`.
  ///
  /// This method uses the predefined [typeGroup] to filter the types of files
  /// that can be selected. If no files are selected, a [PickFilesException] is thrown.
  ///
  /// Throws:
  ///   - [PickFilesException] if no files are picked.
  ///
  /// Returns a list of [XFile] representing the selected files.
  ///
  /// Example:
  /// ```
  /// try {
  ///   final files = await repository.pickFiles();
  ///   // Handle selected files
  /// } catch (e) {
  ///   if (e is PickFilesException) {
  ///     // Handle the case where no files are selected
  ///   }
  /// }
  /// ```
  Future<List<XFile>> pickFiles() async {
    final result = await openFiles(
      acceptedTypeGroups: [typeGroup],
    );
    if (result.isNotEmpty) {
      return result;
    } else {
      throw PickFilesException('No files picked');
    }
  }

  Future<List<String>> uploadFromRawData({
    required List<XFile> files,
    required User user,
  }) async {
    List<String> downloadUrls = [];

    for (var file in files) {
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

      // Build the storage path
      final storagePath = 'users/${user.uid}/uploads/${file.name}';

      // Get the storage reference
      final storageRef = firebaseStorage.ref();

      final fileData = await file.readAsBytes();
      // Upload the file and metadata to the storage reference
      var fileUploaded =
          await storageRef.child(storagePath).putData(fileData, metadata);

      // Get the download URL of the uploaded file and add to the list
      String downloadUrl = await fileUploaded.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }

    return downloadUrls;
  }

  Future<UploadTask> uploadFileFromRawData({
    required XFile file,
    required User user,
  }) async {
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

    // Build the storage path
    final storagePath = 'users/${user.uid}/uploads/${file.name}';

    // Get the storage reference
    final storageRef = firebaseStorage.ref();

    // Read the file as bytes
    final fileData = await file.readAsBytes();

    // Upload the file and metadata to the storage reference
    return storageRef.child(storagePath).putData(fileData, metadata);
  }
}
