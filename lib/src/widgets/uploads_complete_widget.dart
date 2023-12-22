import 'package:firebasestoragemanager/src/widgets/column_header.dart';
import 'package:firebasestoragemanager/src/widgets/column_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UploadsCompleteWidget extends StatelessWidget {
  final VoidCallback onPickFiles;

  const UploadsCompleteWidget({Key? key, required this.onPickFiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColumnSVGImage(
              assetName: 'assets/svg/undraw_completing_re_i7ap.svg',
            ),
            Gap(24),
            ColumnHeader(title: 'Uploads Complete!'),
            Text('This window will automatically close.'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
