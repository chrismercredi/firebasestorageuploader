import 'package:file_selector/file_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../src.dart'; // Make sure this includes your Bloc and other necessary components

class FirebaseStorageManagerScreen extends StatefulWidget {
  const FirebaseStorageManagerScreen({super.key});

  @override
  State<FirebaseStorageManagerScreen> createState() =>
      _FirebaseStorageManagerScreenState();
}

class _FirebaseStorageManagerScreenState
    extends State<FirebaseStorageManagerScreen> {
  // The current authenticated Firebase user.
  final User user = FirebaseAuth.instance.currentUser!;
  // Flag to determine if the platform is web or not.
  final bool isWeb = kIsWeb;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FirebaseStorageManagerBloc,
        FirebaseStorageManagerState>(
      listener: (context, state) {
        if (state is FirebaseStorageManagerSnackbarMessenger) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Firebase Storage Manager'),
            actions: <Widget>[
              const ClearSelectedFilesButton(),
              if (state is FirebaseStorageManagerFilesSelected)
                const UploadSelectedFilesButton(),
              const Gap(24),
            ],
          ),
          body: _buildBodyBasedOnState(context, state),
        );
      },
    );
  }

  Widget _buildBodyBasedOnState(
      BuildContext context, FirebaseStorageManagerState state) {
    if (state is FirebaseStorageManagerInitial) {
      return NoFilesSelectedWidget(
        onSelectFiles: () => context.read<FirebaseStorageManagerBloc>().add(
              FirebaseStorageManagerSelectFiles(),
            ),
      );
    } else if (state is FirebaseStorageManagerFilesSelected) {
      return SelectedFilesStateWidget(
        selectedFiles: state.files,
        onUploadFiles: () => _startUpload(context, state.files),
      );
    } else if (state is FirebaseStorageManagerTasksInProgress ||
        state is FirebaseStorageManagerTasksSnapshot) {
      List<UploadTask> uploadTasks = List<UploadTask>.from(
        (state as dynamic).tasks.map((e) => e.task),
      );
      return UploadingFilesStateWidget(
        uploadTasks: uploadTasks,
        onSelectMoreFiles: () => context.read<FirebaseStorageManagerBloc>().add(
              FirebaseStorageManagerSelectFiles(),
            ),
      );
    } else {
      return Container();
    }
  }

  void _startUpload(BuildContext context, List<XFile> files) {
    if (files.isNotEmpty) {
      context.read<FirebaseStorageManagerBloc>().add(
            FirebaseStorageManagerStartUpload(
                files: files, isWeb: isWeb, user: user),
          );
    }
  }
}
