import 'package:flutter/material.dart';

import '../l10n/uploader_localizations.dart';

/// A button widget that triggers file selection.
class SelectFilesButton extends StatelessWidget {
  /// The function to execute when the button is pressed.
  final VoidCallback onPressed;

  /// Creates a new instance of [SelectFilesButton].
  const SelectFilesButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Text(UploaderLocalizations.of(context).selectFilesButtonLabel),
    );
  }
}
