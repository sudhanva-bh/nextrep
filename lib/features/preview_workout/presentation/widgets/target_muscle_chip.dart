import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class TargetMuscleChip extends StatelessWidget {
  const TargetMuscleChip({
    super.key,
    required this.label,
    this.isPrimary = false,
  });

  final String label;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isPrimary
            ? AppPalette.primary.withAlpha(15)
            : AppPalette.lightSurface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppPalette.outline,
          width: isPrimary ? 1.2 : 0.8,
        ),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppPalette.primary.withAlpha(40),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : [],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Text(
        label,
        style: TextStyle(
          color: isPrimary
              ? AppPalette.primary
              : AppPalette.primary.withAlpha(155),
          fontWeight: isPrimary ? FontWeight.w600 : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }
}
