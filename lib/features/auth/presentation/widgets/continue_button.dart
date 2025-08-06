import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Full width
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          backgroundColor: AppPalette.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          side: BorderSide(
            color: AppPalette.outline,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppPalette.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
