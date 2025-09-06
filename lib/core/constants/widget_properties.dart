import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class WidgetProperties {
  static final dropShadow = [
    BoxShadow(
      color: AppPalette.shadow.withAlpha(155),
      spreadRadius: 2,
      blurRadius: 15,
      offset: Offset(0, 6),
    ),
  ];

  static final subtleDropShadow = [
    BoxShadow(
      color: AppPalette.shadow.withAlpha(100),
      spreadRadius: 0.5,
      blurRadius: 3,
      offset: Offset(0, 3),
    ),
  ];
}
