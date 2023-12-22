import 'package:flutter/material.dart';

import '../src.dart';

class StyledFilledButton extends StatelessWidget {
  const StyledFilledButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: Theme.of(context).blackSquareButtonStyle(),
      onPressed: () {
        onPressed();
      },
      child: Text(buttonText),
    );
  }
}
