import 'package:flutter/material.dart';

class ColumnHeader extends StatelessWidget {
  final String title;

  const ColumnHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        fontFamily: 'Staatliches',
        package: 'firebasestoragemanager',
      ),
    );
  }
}
