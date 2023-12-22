import 'package:flutter/material.dart';

/// Extends [ThemeData] to provide customized theme properties and methods
/// specifically for authentication related UI components.
extension FirebaseStorageThemeExtensions on ThemeData {
  EdgeInsets get pageColumnPadding => const EdgeInsets.fromLTRB(40.0, 0, 40, 0);
  EdgeInsets get formColumnPadding => const EdgeInsets.fromLTRB(40.0, 0, 40, 0);

  TextStyle get loginHeaderStyle => const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        fontFamily: 'Staatliches',
        package: 'supaauth',
      );

  // Email input decorations and styles
  InputDecoration emailInputDecoration() {
    return const InputDecoration(
      labelText: 'Email',
      labelStyle: TextStyle(color: Colors.black),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
    );
  }

  TextStyle emailTextStyle() {
    return const TextStyle(color: Colors.black);
  }

  Color get emailCursorColor => Colors.black;
  double get emailCursorWidth => 4;

  // Password input decorations and styles
  InputDecoration passwordInputDecoration({
    required VoidCallback onTogglePasswordVisibility,
    required bool isPasswordVisible,
  }) {
    return InputDecoration(
      labelText: 'Password',
      labelStyle: const TextStyle(color: Colors.black),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.black,
        ),
        onPressed: onTogglePasswordVisibility,
      ),
    );
  }

  TextStyle passwordTextStyle() {
    return const TextStyle(color: Colors.black);
  }

  Color get passwordCursorColor => Colors.black;
  double get passwordCursorWidth => 4;

  // Confirm password input decorations and styles
  InputDecoration confirmPasswordInputDecoration({
    required VoidCallback onTogglePasswordVisibility,
    required bool isPasswordVisible,
  }) {
    return InputDecoration(
      labelText: 'Confirm Password',
      labelStyle: const TextStyle(color: Colors.black),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.black,
        ),
        onPressed: onTogglePasswordVisibility,
      ),
    );
  }

  TextStyle confirmPasswordTextStyle() {
    return const TextStyle(color: Colors.black);
  }

  Color get confirmPasswordCursorColor => Colors.black;
  double get confirmPasswordCursorWidth => 4;

  // Other button and input styles
  ButtonStyle blackSquareButtonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }

  ButtonStyle blackTextButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }

  ButtonStyle blackOutlinedButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      side: const BorderSide(color: Colors.black),
    );
  }
}
