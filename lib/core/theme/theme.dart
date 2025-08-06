import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppPalette.background,
    primaryColor: AppPalette.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppPalette.primary,
      onPrimary: AppPalette.onPrimary,
      secondary: AppPalette.secondary,
      onSecondary: AppPalette.onSecondary,
      surface: AppPalette.surface,
      onSurface: AppPalette.onSurface,
      error: AppPalette.error,
      onError: AppPalette.onError,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppPalette.onSurface,
      elevation: 0,
    ),
    cardColor: AppPalette.surface,
    disabledColor: AppPalette.disabled,
    dividerColor: AppPalette.outline,
    shadowColor: AppPalette.shadow,
    iconTheme: const IconThemeData(color: AppPalette.onBackground),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppPalette.primary,
      foregroundColor: AppPalette.onPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPalette.primary,
        foregroundColor: AppPalette.onPrimary,
        disabledBackgroundColor: AppPalette.disabled,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.background,
      hintStyle: TextStyle(color: AppPalette.hintText),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppPalette.outline),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppPalette.outlineEnabled, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppPalette.outline),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      labelStyle: TextStyle(color: AppPalette.onBackground),
      floatingLabelStyle: TextStyle(color: AppPalette.onBackground),
    ),
    textTheme:
        GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: AppPalette.onBackground,
          displayColor: AppPalette.onBackground,
        ),
  );
}
