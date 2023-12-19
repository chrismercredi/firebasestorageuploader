import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../src.dart';

/// A widget that displays a list of selected files.
class SelectedFilesList extends StatelessWidget {
  /// The list of selected files to display.
  final List<XFile> selectedFiles;

  /// Creates a new instance of [SelectedFilesList].
  const SelectedFilesList({super.key, required this.selectedFiles});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: selectedFiles
            .map((file) => SelectedFileListTile(file: file))
            .toList(),
      ),
    );
  }
}
