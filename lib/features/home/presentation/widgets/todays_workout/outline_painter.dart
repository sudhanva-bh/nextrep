import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/home/presentation/widgets/todays_workout/clipper.dart';

class OutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = MyCustomClipper().getClip(size);
    final paint = Paint()
      ..color = AppPalette
          .outline // Outline color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
