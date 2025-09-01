import 'package:flutter/material.dart';

class FavouriteWorkoutClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();

    path.moveTo(0.00 * w, 0.24 * h);
    path.lineTo(0.00 * w, 0.77 * h);
    path.quadraticBezierTo(0.01 * w, 0.94 * h, 0.05 * w, 1.00 * h);
    path.lineTo(0.95 * w, 1.00 * h);
    path.quadraticBezierTo(0.98 * w, 0.93 * h, 1.00 * w, 0.78 * h);
    path.lineTo(1.00 * w, 0.46 * h);
    path.lineTo(0.50 * w, 0.46 * h);
    path.quadraticBezierTo(0.48 * w, 0.45 * h, 0.46 * w, 0.39 * h);
    path.lineTo(0.39 * w, 0.07 * h);
    path.quadraticBezierTo(0.37 * w, 0.01 * h, 0.33 * w, -0.00 * h);
    path.lineTo(0.06 * w, 0.00 * h);
    path.quadraticBezierTo(0.01 * w, 0.04 * h, 0.00 * w, 0.24 * h);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
