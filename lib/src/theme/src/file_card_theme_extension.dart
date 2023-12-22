import 'package:flutter/material.dart';

extension FileCardThemeExtension on ThemeData {
  TextStyle get fileCardTitleStyle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      );

  TextStyle get fileCardSubtitleStyle => TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
      );

  EdgeInsets get fileCardMargin => const EdgeInsets.all(8.0);

  // Add more styling properties as needed
}
