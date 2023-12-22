import 'package:firebasestoragemanager/src/widgets/column_elevated_button.dart';
import 'package:firebasestoragemanager/src/widgets/column_header.dart';
import 'package:firebasestoragemanager/src/widgets/column_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EmptyListWidget extends StatelessWidget {
  final VoidCallback onPickFiles;

  const EmptyListWidget({Key? key, required this.onPickFiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ColumnSVGImage(
              assetName: 'assets/svg/undraw_add_files_re_v09g.svg',
            ),
            const Gap(24),
            const ColumnHeader(title: 'File Picker'),
            const Text('No files selected. Tap the button to pick files.'),
            const SizedBox(height: 20),
            ColumnElevatedButton(
              isLoading: false,
              buttonText: 'Pick Files',
              onPressed: onPickFiles,
            )
          ],
        ),
      ),
    );
  }
}
