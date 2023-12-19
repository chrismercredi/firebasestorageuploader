import 'package:flutter/material.dart';
import 'package:keyedai/src/uploader/uploader.dart';

/// A button widget that allows selecting more files.
class SelectMoreFilesButton extends StatelessWidget {
  /// The function to execute when the button is pressed.
  final VoidCallback onPressed;

  /// Creates a new instance of [SelectMoreFilesButton].
  const SelectMoreFilesButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final uploaderLocalizations = UploaderLocalizations.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(uploaderLocalizations.selectMoreFilesButtonLabel),
    );
  }
}
