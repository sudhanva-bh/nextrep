import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

// Data class to hold category info
class BmiInfo {
  final String category;
  final String description;
  final Color color;

  BmiInfo({
    required this.category,
    required this.description,
    required this.color,
  });
}

// Calculates BMI from weight (kg) and height (cm)
double calculateBmi(double weightKg, double heightCm) {
  if (heightCm <= 0) return 0;
  final heightM = heightCm / 100;
  return weightKg / (heightM * heightM);
}

// Returns the category, description, and color for a given BMI value
BmiInfo getBmiInfo(double bmi) {
  if (bmi <= 0) {
    return BmiInfo(
      category: 'N/A',
      description: 'Enter weight and height.',
      color: AppPalette.onSurface,
    );
  }
  if (bmi < 18.5) {
    return BmiInfo(
      category: 'Underweight',
      description: 'You are below the healthy weight range.',
      color: const Color(0xFF3498DB), // Blue
    );
  } else if (bmi < 25) {
    return BmiInfo(
      category: 'Healthy',
      description: 'You are within the healthy weight range.',
      color: const Color(0xFF2ECC71), // Green
    );
  } else if (bmi < 30) {
    return BmiInfo(
      category: 'Overweight',
      description: 'You are above the healthy weight range.',
      color: AppPalette.primary, // Orange
    );
  } else {
    return BmiInfo(
      category: 'Obese',
      description: 'You are in the obese weight range.',
      color: AppPalette.error, // Red
    );
  }
}