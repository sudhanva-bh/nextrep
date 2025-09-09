import 'package:flutter/material.dart';
import 'package:nextrep/core/common/utils/bmi_calculator.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class CurrentBmiCard extends StatelessWidget {
  final double bmi;
  final BmiInfo info;

  const CurrentBmiCard({
    super.key,
    required this.bmi,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: WidgetProperties.dropShadow,
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current BMI',
                  style: TextStyle(
                    color: AppPalette.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  bmi.toStringAsFixed(1),
                  style: TextStyle(
                    color: info.color,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  info.description,
                  style: const TextStyle(
                    color: AppPalette.hintText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              boxShadow: WidgetProperties.subtleDropShadow,
              color: info.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              info.category,
              style: TextStyle(
                color: info.color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
