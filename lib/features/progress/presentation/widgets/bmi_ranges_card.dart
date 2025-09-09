import 'package:flutter/material.dart';
import 'package:nextrep/core/common/utils/bmi_calculator.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class BmiRangesCard extends StatelessWidget {
  const BmiRangesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BMI Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppPalette.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            boxShadow: WidgetProperties.dropShadow,
            color: AppPalette.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildRangeRow(getBmiInfo(18.4), '< 18.5'),
              const SizedBox(height: 12),
              _buildRangeRow(getBmiInfo(22), '18.5 - 24.9'),
              const SizedBox(height: 12),
              _buildRangeRow(getBmiInfo(27), '25.0 - 29.9'),
              const SizedBox(height: 12),
              _buildRangeRow(getBmiInfo(31), '≥ 30.0'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRangeRow(BmiInfo info, String range) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: info.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          info.category,
          style: const TextStyle(
            color: AppPalette.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          range,
          style: const TextStyle(
            color: AppPalette.hintText,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
