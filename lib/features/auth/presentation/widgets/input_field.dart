import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

enum FieldAlignment {
  top,
  center,
  bottom,
}

enum FieldType {
  name,
  email,
  password,
}

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final FieldAlignment alignment;
  final FieldType fieldType;
  final double radius;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.alignment = FieldAlignment.center,
    this.fieldType = FieldType.name,
    this.radius = 18,
    this.validator,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late BorderRadius _borderRadius;
  late TextCapitalization _textCapitalization;
  late bool _isPassword;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();

    _textCapitalization = widget.fieldType == FieldType.name
        ? TextCapitalization.words
        : TextCapitalization.none;

    _borderRadius = switch (widget.alignment) {
      FieldAlignment.top => BorderRadius.vertical(
        top: Radius.circular(widget.radius),
      ),
      FieldAlignment.bottom => BorderRadius.vertical(
        bottom: Radius.circular(widget.radius),
      ),
      _ => BorderRadius.circular(0),
    };

    _isPassword = widget.fieldType == FieldType.password;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      textCapitalization: _textCapitalization,
      obscureText: _isPassword && !_showPassword,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white70,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: AppPalette.hintText),
        filled: true,
        fillColor: AppPalette.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: const BorderSide(color: AppPalette.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: const BorderSide(
            color: AppPalette.inverseSurface,
            width: 1.5,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: const BorderSide(color: AppPalette.outline),
        ),
        suffixIcon: _isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                icon: Icon(
                  _showPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              )
            : null,
      ),
    );
  }
}
