import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class NonCutOutText extends StatelessWidget {
  const NonCutOutText({
    super.key,
    required this.text,
    this.fontSize = 40.0,
    this.strokeWidth = 1.5,
    this.fillColor = AppPalette.inverseSurface,
    this.strokeColor = Colors.black,
  });

  final String text;
  final double fontSize;
  final double strokeWidth;
  final Color fillColor;
  final Color strokeColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Border
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // Fill
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: fillColor,
          ),
        ),
      ],
    );
  }
}
