import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class NumberInputCard extends StatelessWidget {
  final double width;
  final String? hintText;
  final String initialValue; // Add this to control the initial text
  final Function(double param) onChanged;
  final bool isDecimal; // Add this flag

  const NumberInputCard({
    super.key,
    this.width = 80,
    this.hintText,
    required this.initialValue,
    required this.onChanged,
    this.isDecimal = false, // Default to false for reps
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: double.infinity, // take all available height
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppPalette.lightSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: TextField(
          controller: TextEditingController(text: initialValue),
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          keyboardType: isDecimal
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
          inputFormatters: [
            // Use a regex that allows decimals only if isDecimal is true
            if (isDecimal)
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
            else
              FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          textAlign: TextAlign.center,
          onChanged: (value) {
            // Safely parse the text to a double and call the callback
            final numberValue = double.tryParse(value) ?? 0.0;
            onChanged(numberValue);
          },
        ),
      ),
    );
  }
}
