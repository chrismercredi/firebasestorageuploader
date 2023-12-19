import 'package:file_selector/file_selector.dart';
import 'package:firebasestoragemanager/src/src.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';

/// A widget that displays information about a selected file.
///
/// This widget is designed to present details of a file chosen by the user.
/// It shows the file's name, path (except on web due to security restrictions),
/// MIME type, and size. The file size is displayed in a human-readable format.
///
/// The widget adapts its behavior based on the platform. On web platforms,
/// it provides a delete button, while on mobile platforms, it allows the file
/// to be dismissible with a swipe gesture.
///
/// Example Usage:
/// ```dart
/// SelectedFileListTile(file: myXFile);
/// ```
class SelectedFileListTile extends StatelessWidget {
  /// The [XFile] to display information about.
  final XFile file;

  /// Creates a [SelectedFileListTile].
  ///
  /// Requires a [file] parameter which is the selected file whose details
  /// are to be displayed.
  const SelectedFileListTile({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? mimeType = lookupMimeType(file.path);
    final UploaderLocalizations localizations =
        UploaderLocalizations.of(context);

    FutureBuilder<int> fileDetails = FutureBuilder<int>(
      future: file.length(),
      builder: (context, snapshot) {
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
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              print('delete event dispatch');
              context.read<FirebaseStorageManagerBloc>().add(
                    FirebaseStorageManagerRemoveSelectedFile(file),
                  );
            },
          ),
        );
      },
    );

    // Wrapping the ListTile with Dismissible for mobile platforms
    if (!kIsWeb) {
      return Dismissible(
        key: Key(file.path),
        background: Container(
          color: Theme.of(context).colorScheme.error,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.delete,
                  color: Theme.of(context).colorScheme.onError),
            ),
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          context.read<FirebaseStorageManagerBloc>().add(
                FirebaseStorageManagerRemoveSelectedFile(file),
              );
        },
        child: fileDetails,
      );
    }

    // Return the ListTile directly for web/desktop platforms
    return fileDetails;
  }
}
