import 'package:file_selector/file_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src.dart';

class UploadSelectedFilesButton extends StatelessWidget {
  const UploadSelectedFilesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.cloud_upload),
      onPressed: () {
        // Get the current state from the Bloc
        var currentState = context.read<FirebaseStorageManagerBloc>().state;

        // Check if the current state is FirebaseStorageManagerFilesSelected
        if (currentState is FirebaseStorageManagerFilesSelected) {
          // If so, get the list of files and start the upload
          _startUpload(context, currentState.files);
        } else {
          // If the state is not FirebaseStorageManagerFilesSelected, handle accordingly
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("No files are currently selected for upload")),
          );
        }
      },
    );
  }

  void _startUpload(BuildContext context, List<XFile> files) {
    if (files.isNotEmpty) {
      // Dispatch the upload event
      context.read<FirebaseStorageManagerBloc>().add(
            FirebaseStorageManagerStartUpload(
              files: files,
              isWeb: kIsWeb,
              user: FirebaseAuth.instance.currentUser!,
            ),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No files selected to upload")),
      );
    }
  }
}
