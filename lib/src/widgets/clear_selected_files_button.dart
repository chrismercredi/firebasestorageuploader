import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src.dart';

class ClearSelectedFilesButton extends StatelessWidget {
  const ClearSelectedFilesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.clear_all),
      onPressed: () => context
          .read<FirebaseStorageManagerBloc>()
          .add(FirebaseStorageManagerClearSelectedFiles()),
    );
  }
}
