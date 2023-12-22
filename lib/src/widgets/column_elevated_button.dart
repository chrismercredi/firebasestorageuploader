import 'package:flutter/material.dart';

import '../src.dart';

class ColumnElevatedButton extends StatelessWidget {
  final bool isLoading;
  final String buttonText;
  final VoidCallback onPressed;

  const ColumnElevatedButton({
    Key? key,
    required this.isLoading,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: Theme.of(context).blackSquareButtonStyle(),
        child: Text(isLoading ? 'Loading' : buttonText),
      ),
    );
  }
}
