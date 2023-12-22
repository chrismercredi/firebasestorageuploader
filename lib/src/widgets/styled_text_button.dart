import 'package:flutter/material.dart';

import '../src.dart';

class StyledTextButton extends StatelessWidget {
  const StyledTextButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  final VoidCallback onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: Theme.of(context).blackTextButtonStyle(),
      onPressed: () {
        onPressed();
      },
      child: Text(buttonText),
    );
  }
}
