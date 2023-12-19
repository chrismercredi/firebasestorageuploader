import 'package:flutter/material.dart';

import '../l10n/uploader_localizations.dart';
import '../src.dart';

/// A widget representing the state where files can be selected.
class SelectFilesStateWidget extends StatelessWidget {
  /// The function to execute to trigger file selection.
  final VoidCallback onSelectFiles;

  /// Creates a new instance of [SelectFilesStateWidget].
  const SelectFilesStateWidget({super.key, required this.onSelectFiles});

  @override
  Widget build(BuildContext context) {
    final uploaderLocalizations = UploaderLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 250, // Minimum width
            maxWidth: 500, // Maximum width
          ),
          child: Card(
            elevation: 1,
            color: Theme.of(context).colorScheme.surface,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.error_sharp,
                  color: Theme.of(context).colorScheme.primary,
                  size: 36,
                ),
                title: Text(
                  uploaderLocalizations.noFilesSelectedTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  uploaderLocalizations.pickFilesToStartSubtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: SelectFilesButton(onPressed: onSelectFiles),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
