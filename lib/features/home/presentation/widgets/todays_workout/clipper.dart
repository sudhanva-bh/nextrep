import 'package:flutter/material.dart';

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();

    path.moveTo(0.00 * w, 0.07 * h);
    path.lineTo(0.00 * w, 0.93 * h);
    path.quadraticBezierTo(0.01 * w, 0.99 * h, 0.03 * w, 1.00 * h);
    path.lineTo(0.97 * w, 1.00 * h);
    path.quadraticBezierTo(0.99 * w, 0.99 * h, 1.00 * w, 0.97 * h);
    path.lineTo(1.00 * w, 0.25 * h);
    path.quadraticBezierTo(0.99 * w, 0.19 * h, 0.94 * w, 0.18 * h);
    path.lineTo(0.50 * w, 0.18 * h);
    path.quadraticBezierTo(0.48 * w, 0.18 * h, 0.46 * w, 0.16 * h);
    path.lineTo(0.38 * w, 0.03 * h);
    path.quadraticBezierTo(0.37 * w, 0.01 * h, 0.34 * w, 0.00 * h);
    path.lineTo(0.06 * w, 0.00 * h);
    path.quadraticBezierTo(0.01 * w, 0.01 * h, 0.00 * w, 0.07 * h);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
