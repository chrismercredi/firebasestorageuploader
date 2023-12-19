import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../src.dart';

class UploadingFilesStateWidget extends StatelessWidget {
  final List<UploadTask> uploadTasks;
  final VoidCallback onSelectMoreFiles;

  const UploadingFilesStateWidget({
    Key? key,
    required this.uploadTasks,
    required this.onSelectMoreFiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UploadTasksList(uploadTasks: uploadTasks),
        SelectMoreFilesButton(onPressed: onSelectMoreFiles),
      ],
    );
  }
}
