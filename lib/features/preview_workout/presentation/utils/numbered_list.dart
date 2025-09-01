import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class NumberedList extends StatelessWidget {
  final List<String> items;
  final double spacing;
  final TextStyle? numberStyle;
  final TextStyle? textStyle;

  const NumberedList({
    super.key,
    required this.items,
    this.spacing = 1.0,
    this.numberStyle,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}. ',
              ),
              Expanded(
                child: Text(
                  items[index],
                  style:
                      textStyle ??
                      TextStyle(fontSize: 16, color: AppPalette.onSurface),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
