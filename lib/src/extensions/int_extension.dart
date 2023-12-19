import 'package:flutter/widgets.dart';
import 'package:keyedai/src/uploader/l10n/uploader_localizations.dart';

/// Extension on [int] to provide file size formatting functionality.
extension FileSize on int {
  /// Returns a human-readable file size string.
  ///
  /// The function checks the magnitude of the file size and formats it with the appropriate
  /// unit, ranging from bytes to terabytes. It uses localized strings for the units.
  String fileSize(BuildContext context) {
    const int kilobyte = 1024;
    const int megabyte = kilobyte * 1024;
    const int gigabyte = megabyte * 1024;
    const int terabyte = gigabyte * 1024;

    final UploaderLocalizations localizations =
        UploaderLocalizations.of(context);

    if (this < kilobyte) {
      return '$this ${localizations.bytes}';
    } else if (this < megabyte) {
      return '${(this / kilobyte).toStringAsFixed(2)} ${localizations.kilobytes}';
    } else if (this < gigabyte) {
      return '${(this / megabyte).toStringAsFixed(2)} ${localizations.megabytes}';
    } else if (this < terabyte) {
      return '${(this / gigabyte).toStringAsFixed(2)} ${localizations.gigabytes}';
    } else {
      return '${(this / terabyte).toStringAsFixed(2)} ${localizations.terabytes}';
    }
  }
}
