import 'package:file_selector/file_selector.dart';
import 'package:firebasestoragemanager/src/src.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

import '../l10n/uploader_localizations.dart';

/// A widget that displays information about a selected file.
///
/// This widget takes a [XFile] as input and displays its name, path (except on web),
/// MIME type, and size. The file size is formatted to be human-readable.
class SelectedFileListTile extends StatelessWidget {
  /// The file to display information about.
  final XFile file;

  /// Creates a [SelectedFileListTile] widget.
  ///
  /// The [file] parameter must not be null.
  const SelectedFileListTile({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    // Determine the MIME type of the file.
    final String? mimeType = lookupMimeType(file.path);
    final UploaderLocalizations localizations =
        UploaderLocalizations.of(context);

    return FutureBuilder<int>(
      future: file.length(),
      builder: (context, snapshot) {
        // Format the file size, or show a placeholder if it's not yet calculated.
        final String fileSize = snapshot.hasData
            ? snapshot.data!.fileSize(context)
            : localizations.calculatingFileSize;

        return ListTile(
          title: Text(file.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!kIsWeb) Text('${localizations.filePathLabel}: ${file.path}'),
              if (mimeType != null)
                Text('${localizations.fileTypeLabel}: $mimeType'),
              Text('${localizations.fileSizeLabel}: $fileSize'),
            ],
          ),
        );
      },
    );
  }
}
