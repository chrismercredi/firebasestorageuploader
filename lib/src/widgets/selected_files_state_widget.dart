import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../src.dart';

class SelectedFilesStateWidget extends StatelessWidget {
  final List<XFile> selectedFiles;
  final VoidCallback onUploadFiles;

  const SelectedFilesStateWidget({
    super.key,
    required this.selectedFiles,
    required this.onUploadFiles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SelectedFilesList(),
        UploadFilesButton(onPressed: onUploadFiles),
      ],
    );
  }
}
