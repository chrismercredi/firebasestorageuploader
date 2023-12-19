import 'package:flutter/material.dart';

import '../l10n/uploader_localizations.dart';

class UploadFilesButton extends StatelessWidget {
  final VoidCallback onPressed;

  const UploadFilesButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final uploaderLocalizations = UploaderLocalizations.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(uploaderLocalizations.uploadFilesButtonLabel),
    );
  }
}
