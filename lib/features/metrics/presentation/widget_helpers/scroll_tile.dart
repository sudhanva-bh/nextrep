import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class ScrollTile extends StatelessWidget {
  const ScrollTile({
    super.key,
    required this.text,
    required this.isSelected,
    this.onClicked,
  });
  final String text;
  final bool isSelected;
  final VoidCallback? onClicked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 100),
          style: TextStyle(
            fontSize: isSelected ? 44 : 32,
            color: isSelected ? AppPalette.onBackground : AppPalette.disabled,
            fontWeight: FontWeight.bold,
          ),
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
