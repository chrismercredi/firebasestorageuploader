import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ColumnSVGImage extends StatelessWidget {
  final String assetName;
  final double width;

  const ColumnSVGImage({
    Key? key,
    required this.assetName,
    this.width = 240,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      package: 'firebasestoragemanager',
      width: width,
    );
  }
}
