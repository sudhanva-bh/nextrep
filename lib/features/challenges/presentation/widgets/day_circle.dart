
import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class _DayCircle extends StatelessWidget {
  final int dayNumber;
  final bool isDone;
  final VoidCallback onTap;

  const _DayCircle({
    required this.dayNumber,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDone ? AppPalette.primary : AppPalette.surface,
          border: Border.all(
            color: isDone ? AppPalette.primary : AppPalette.outline,
            width: 2,
          ),
        ),
        child: Center(
          child: isDone
              ? const Icon(Icons.check, color: AppPalette.onPrimary, size: 24)
              : Text(
                  '$dayNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}