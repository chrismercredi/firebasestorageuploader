import 'package:flutter/material.dart';

extension FABThemeExtension on ThemeData {
  FloatingActionButtonThemeData get pickFilesFABTheme =>
      const FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        // Customize other properties as needed
      );

  FloatingActionButtonThemeData get uploadFilesFABTheme =>
      const FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        // Customize other properties as needed
      );
}
