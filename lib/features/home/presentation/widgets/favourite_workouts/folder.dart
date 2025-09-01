import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/home/presentation/widgets/favourite_workouts/clipper.dart';
import 'package:nextrep/features/home/presentation/widgets/favourite_workouts/outline_painter.dart';

class FavouriteFolder extends StatelessWidget {
  const FavouriteFolder({super.key, required this.child, this.height = 317});
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: FavouriteWorkoutClipper(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppPalette.surface.withAlpha(120),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: FavouritesOutlinePainter(),
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
