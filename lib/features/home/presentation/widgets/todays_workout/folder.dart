import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/home/presentation/widgets/todays_workout/clipper.dart';
import 'package:nextrep/features/home/presentation/widgets/todays_workout/outline_painter.dart';

class Folder extends StatelessWidget {
  const Folder({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyCustomClipper(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 317,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppPalette.surface.withAlpha(120),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: OutlinePainter(),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
