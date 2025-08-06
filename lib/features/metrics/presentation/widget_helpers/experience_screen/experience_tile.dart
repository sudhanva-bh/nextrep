import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

enum Experience {
  beginner,
  intermediate,
  advanced,
}

class ExperienceTile extends StatelessWidget {
  const ExperienceTile({
    super.key,
    required this.enabled,
    required this.gender,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  final bool enabled;
  final Experience gender;

  String get genderName {
    switch (gender) {
      case Experience.beginner:
        return "Beginner";
      case Experience.intermediate:
        return "Intermediate";
      case Experience.advanced:
        return "Advanced";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        width: 170,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: enabled ? AppPalette.selectedSurface : AppPalette.surface,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(
            color: enabled ? AppPalette.selectedBorder : AppPalette.outline,
            width: enabled ? 2.5 : 1,
          ),
        ),
        duration: Duration(milliseconds: 100),
        child: Center(
          child: Text(
            genderName,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
