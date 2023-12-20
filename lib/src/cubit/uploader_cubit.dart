// import 'dart:io' as io;
// import 'dart:math' as math;

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:file_selector/file_selector.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:mime/mime.dart';

// part 'uploader_state.dart';

// /// `UploaderCubit` manages the state for uploading files.
// ///
// /// It extends `Cubit` with the state being `UploaderState`.
// class UploaderCubit extends Cubit<UploaderState> {
//   /// Creates an `UploaderCubit` with the initial state being `UploaderInitial`.
//   UploaderCubit() : super(UploaderInitial());

//   /// Defines the types of files that can be selected.
//   final XTypeGroup typeGroup = const XTypeGroup(
//     label: 'Files',
//     extensions: <String>[
//       // Images
//       'jpg', 'jpeg', 'png',
//       // Word documents
//       'doc', 'docx',
//       // Excel spreadsheets
//       'xls', 'xlsx',
//       // PowerPoint presentations
//       'ppt', 'pptx',
//       // PDFs
//       'pdf',
//       // SVGs
//       'svg',
//       // Text and Rich Text Format
//       'txt', 'rtf',
//     ],
//   );

//   final List<UploaderTaskInfo> _uploadTasks = [];

//   /// Clears all upload tasks and emits `UploaderInitial`.
//   void clearUploadTasks() {
//     _uploadTasks.clear();
//     emit(UploaderInitial());
//   }

//   /// Starts the upload process for selected files.
//   ///
//   /// It takes [isWeb] to determine the platform, and [user] to define the user.
//   void startUpload(bool isWeb, User user) {
//     if (state is UploaderFilesSelected) {
//       final selectedFiles = (state as UploaderFilesSelected).files;
//       uploadFile(selectedFiles, isWeb, user);
//     }
//   }

//   /// Opens the file selector and emits `UploaderFilesSelected` with the result.
//   Future<void> openMultipleFiles() async {
//     try {
//       final result = await openFiles(acceptedTypeGroups: [typeGroup]);
//       if (result.isNotEmpty) {
//         emit(UploaderFilesSelected(result));
//       }
//     } catch (e) {
//       if (e is UploaderCancelledException) {
//         emit(UploaderInitial());
//       } else {
//         rethrow;
//       }
//     }
//   }

//   /// Uploads a list of [files].
//   ///
//   /// It takes [isWeb] to determine the platform, and [user] to define the user.
//   Future<void> uploadFile(List<XFile?> files, bool isWeb, User user) async {
//     if (files.isEmpty) {
//       emit(const SnackbarMessenger('No files selected'));
//       return;
//     }

//     String uid = user.uid;

//     for (var file in files) {
//       if (file == null) continue;

//       UploadTask uploadTask;

//       Reference ref = FirebaseStorage.instance
//           .ref()
//           .child('users')
//           .child(uid)
//           .child('uploads')
//           .child(file.name);

//       String? mimeType;

//       if (isWeb) {
//         final data = await file.readAsBytes();
//         mimeType = lookupMimeType(file.path,
//             headerBytes: data.sublist(0, math.min(12, data.length)));
//         uploadTask = ref.putData(data, SettableMetadata(contentType: mimeType));
//       } else {
//         final io.File localFile = io.File(file.path);
//         mimeType = lookupMimeType(file.path,
//             headerBytes: await localFile.openRead().first);
//         uploadTask =
//             ref.putFile(localFile, SettableMetadata(contentType: mimeType));
//       }

//       var uploaderTaskInfo = UploaderTaskInfo(uploadTask, null);
//       _uploadTasks.add(uploaderTaskInfo);

//       // Emit a state to represent the ongoing upload.
//       emit(UploaderTasksInProgress(List.from(_uploadTasks)));

//       // Listen to the upload task’s progress.
//       uploadTask.snapshotEvents.listen(
//         (TaskSnapshot snapshot) {
//           uploaderTaskInfo.snapshot = snapshot;
//           // Emit a state with the updated snapshot.
//           emit(UploaderTasksSnapshot(List.from(_uploadTasks)));
//         },
//         onError: (e) {
//           // Handle any errors that occur during the upload.
//           emit(SnackbarMessenger('Upload failed: $e'));
//         },
//         onDone: () async {
//           // Wait for the upload to complete
//           await uploadTask;
//           // Handle completion of the upload.
//           emit(const SnackbarMessenger('Upload complete!'));
//           // Optionally, you can also remove the completed task from the list
//           _uploadTasks.remove(uploaderTaskInfo);
//           if (_uploadTasks.isEmpty) {
//             emit(UploaderInitial());
//           } else {
//             emit(UploaderTasksSnapshot(List.from(_uploadTasks)));
//           }
//         },
//       );
//     }
//   }
// }

// /// `UploaderTaskInfo` holds information about an upload task.
// class UploaderTaskInfo {
//   /// The `UploadTask` associated with this upload.
//   final UploadTask task;

//   /// The `TaskSnapshot` associated with this upload, can be null.
//   TaskSnapshot? snapshot;

//   /// Creates a new instance of `UploaderTaskInfo`.
//   UploaderTaskInfo(this.task, this.snapshot);
// }
