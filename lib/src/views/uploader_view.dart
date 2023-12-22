// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../src.dart';

// /// A widget that provides an interface for uploading files.
// ///
// /// It interacts with Firebase to upload files and provides a user interface
// /// to select, view, and manage the upload process. It is designed to work
// /// both on web and mobile platforms.
// class UploaderView extends StatelessWidget {
//   /// The current authenticated Firebase user.
//   final User user;

//   /// A boolean value indicating whether the application is running in a web environment.
//   final bool isWeb;

//   /// Creates a new instance of [UploaderView].
//   ///
//   /// Requires [user] parameter for Firebase authentication and [isWeb] to
//   /// determine the platform the application is running on.
//   const UploaderView({Key? key, required this.user, required this.isWeb})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final uploaderLocalizations = UploaderLocalizations.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: ListTile(
//           title: Text(uploaderLocalizations.fileUploaderTitle),
//           subtitle: Text(uploaderLocalizations.supportedFileTypes),
//         ),
//       ),
//       body: BlocConsumer<FirebaseStorageUploaderBloc,
//           FirebaseStorageManagerState>(
//         listener: (context, state) {
//           // When the state is SnackbarMessenger, show a snackbar with the message.
//           if (state is FirebaseStorageManagerSnackbarMessenger) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         builder: (context, state) {
//           // Based on the current state, return the appropriate widget.
//           if (state is FirebaseStorageManagerInitial) {
//             return NoFilesSelectedWidget(
//               onSelectFiles: () => context
//                   .read<FirebaseStorageUploaderBloc>()
//                   .openMultipleFiles(),
//             );
//           } else if (state is FirebaseStorageManagerFilesSelected) {
//             return SelectedFilesStateWidget(
//               selectedFiles: state.files,
//               onUploadFiles: () => context
//                   .read<FirebaseStorageUploaderBloc>()
//                   .startUpload(isWeb, user),
//             );
//           } else if (state is FirebaseStorageManagerTasksInProgress ||
//               state is FirebaseStorageManagerTasksSnapshot) {
//             List<UploadTask> uploadTasks = List<UploadTask>.from(
//               (state as dynamic).tasks.map((e) => e.task),
//             );
//             return UploadingFilesStateWidget(
//               uploadTasks: uploadTasks,
//               onSelectMoreFiles: () => context
//                   .read<FirebaseStorageUploaderBloc>()
//                   .openMultipleFiles(),
//             );
//           } else {
//             // For unsupported states, return an empty container.
//             return Container();
//           }
//         },
//       ),
//     );
//   }
// }
