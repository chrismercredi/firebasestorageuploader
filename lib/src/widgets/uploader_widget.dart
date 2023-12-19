import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasestoragemanager/src/l10n/uploader_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../src.dart';

/// A widget that provides the uploader functionality.
///
/// It checks the authentication state using Firebase and shows the [UploaderView]
/// if the user is authenticated. Otherwise, it shows a message
/// indicating that the user is not authenticated.
class UploaderWidget extends StatelessWidget {
  const UploaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final uploaderLocalizations = UploaderLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser;

    // Check if the user is authenticated
    if (user != null) {
      // User is authenticated, show the UploaderView
      return UploaderView(
          user: user,
          isWeb: kIsWeb); // Update as per your UploaderView's constructor
    }
    // User is not authenticated, show a fallback widget
    return Center(
      child: Text(uploaderLocalizations.userNotAuthenticated),
    );
  }
}
