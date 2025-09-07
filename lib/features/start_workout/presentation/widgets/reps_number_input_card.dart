import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class RepsNumberInputCard extends StatefulWidget {
  final double width;
  final String? hintText;
  final String initialValue;
  final Function(double param) onChanged;
  final bool isDecimal;
  final bool isDone;

  const RepsNumberInputCard({
    super.key,
    this.width = 75,
    this.hintText,
    required this.initialValue,
    required this.onChanged,
    this.isDecimal = false,
    required this.isDone,
  });

  @override
  State<RepsNumberInputCard> createState() => _RepsNumberInputCardState();
}

class _RepsNumberInputCardState extends State<RepsNumberInputCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant RepsNumberInputCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  void _changeValue(bool increment) {
    final currentValue = double.tryParse(_controller.text) ?? 0.0;
    final step = widget.isDecimal ? 2.5 : 1.0;
    final newValue = increment ? currentValue + step : currentValue - step;

    _controller.text = widget.isDecimal
        ? newValue.toStringAsFixed(1)
        : newValue.toInt().toString();

    // Move cursor to end
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );

    widget.onChanged(newValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;

        if (details.primaryVelocity! > 0) {
          // swipe right
          _changeValue(true);
        } else if (details.primaryVelocity! < 0) {
          // swipe left
          _changeValue(false);
        }
      },
      child: Container(
        width: widget.width,
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          controller: _controller,
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
          textAlign: TextAlign.center,
          onChanged: (value) {
            final numberValue = double.tryParse(value) ?? 0.0;
            widget.onChanged(numberValue);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.isDone
                ? AppPalette.lightSurface
                : AppPalette.lighterSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          ),
        ),
      ),
    );
  }
}
