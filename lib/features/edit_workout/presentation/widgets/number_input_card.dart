import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class NumberInputCard extends StatefulWidget {
  final double width;
  final String? hintText;
  final String initialValue;
  final Function(double param) onChanged;
  final bool isDecimal;

  const NumberInputCard({
    super.key,
    this.width = 65,
    this.hintText,
    required this.initialValue,
    required this.onChanged,
    this.isDecimal = false,
  });

  @override
  State<NumberInputCard> createState() => _NumberInputCardState();
}

class _NumberInputCardState extends State<NumberInputCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant NumberInputCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the controller's text if the initialValue from the parent changes,
    // but only if the user isn't currently editing it.
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppPalette.lightSurface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: WidgetProperties.subtleDropShadow,
      ),
      child: Center(
        child: TextField(
          controller: _controller, // Use the stateful controller
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          keyboardType: widget.isDecimal
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
          inputFormatters: [
            if (widget.isDecimal)
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
            else
              FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            fillColor: AppPalette.lighterSurface,
            hintText: widget.hintText,
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          textAlign: TextAlign.center,
          onChanged: (value) {
            final numberValue = double.tryParse(value) ?? 0.0;
            widget.onChanged(numberValue);
          },
        ),
      ),
    );
  }
}
