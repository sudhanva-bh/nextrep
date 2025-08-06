import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class WeeklyItem extends StatelessWidget {
  const WeeklyItem({
    super.key,
    required this.week,
    required this.isDone,
  });

  final String week;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDone ? AppPalette.primary : AppPalette.onSurface,
              width: 4,
            ),
            color: Colors.transparent,
          ),
          child: isDone
              ? Icon(
                  Icons.done_outline,
                  size: 18,
                  color: AppPalette.primary,
                )
              : SizedBox(),
        ),
        SizedBox(height: 5),
        Text(
          week,
          style: TextStyle(
            color: AppPalette.onSecondary,
          ),
        ),
      ],
    );
  }
}
