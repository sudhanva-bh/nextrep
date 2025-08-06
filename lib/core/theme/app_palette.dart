import 'package:flutter/material.dart';

class AppPalette {
  // Core Colors
  static const Color primary = Color(0xFFFF9800); // Orange
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFF7C4DFF); // Deep Purple
  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color background = Color(0xFF121212); // Almost black
  static const Color onBackground = Color(0xFFE0E0E0); // Light gray

  static const Color surface = Color(0xFF1E1E1E); // Card/Sheet background
  static const Color lightSurface = Color(0xFF393939);
  static const Color lighterSurface = Color(0xFF6B6B6B);
  static const Color onSurface = Color(0xFFDADADA); // Text on surface

  static const Color error = Color(0xFFCF6679); // Material dark red
  static const Color onError = Color(0xFFFFFFFF);

  static const Color hintText = Colors.white70;

  // Inverse Colors (for light elements in dark theme)
  static const Color inverseSurface = Color(
    0xFFF5F5F5,
  ); // Light gray background
  static const Color inverseOnSurface = Color(
    0xFF121212,
  ); // Text on light background

  static const Color inversePrimary = Color(0xFFFFA726); // Lighter orange
  static const Color inverseOnPrimary = Color(
    0xFF212121,
  ); // Dark text on light orange

  // Utility Colors
  static const Color outline = Color(0xFF2C2C2C); // Borders/dividers
  static const Color outlineEnabled = Color(
    0xFF5E5E5E,
  ); // Borders/dividers Enabled
  static const Color disabled = Color(0xFF3A3A3A); // Disabled buttons, icons
  static const Color shadow = Color(0xFF000000); // Shadows with opacity

  static const Color transparent = Color(0x00000000);

  static const Color selectedBorder = Color(0xFFFFB74D); // Light orange border
  static const Color selectedSurface = Color.fromARGB(
    42,
    255,
    153,
    0,
  ); // Transparent orange background
}
