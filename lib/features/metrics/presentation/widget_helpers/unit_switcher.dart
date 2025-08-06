import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class UnitSwitcher extends StatelessWidget {
  final VoidCallback onUnit1Pressed;
  final VoidCallback onUnit2Pressed;
  final bool isCmSelected;
  final String unit1;
  final String unit2;

  const UnitSwitcher({
    super.key,
    required this.onUnit1Pressed,
    required this.onUnit2Pressed,
    required this.isCmSelected,
    required this.unit1,
    required this.unit2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppPalette.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPalette.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // CM Button
          Expanded(
            child: GestureDetector(
              onTap: onUnit1Pressed,
              child: Container(
                decoration: BoxDecoration(
                  color: isCmSelected ? AppPalette.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  unit1,
                  style: TextStyle(
                    color: isCmSelected
                        ? AppPalette.onPrimary
                        : AppPalette.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // IN Button
          Expanded(
            child: GestureDetector(
              onTap: onUnit2Pressed,
              child: Container(
                decoration: BoxDecoration(
                  color: !isCmSelected
                      ? AppPalette.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  unit2,
                  style: TextStyle(
                    color: !isCmSelected
                        ? AppPalette.onPrimary
                        : AppPalette.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
