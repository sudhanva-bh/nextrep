import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class ContinueWithButton extends StatelessWidget {
  const ContinueWithButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 55.0),
        backgroundColor: AppPalette.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Icon(
        icon,
        color: AppPalette.onSurface,
        size: 24,
      ),
    );
  }
}
