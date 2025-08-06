import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class BmiSlider extends StatelessWidget {
  const BmiSlider({
    super.key,
    required this.bmi,
    required this.targetBmi,
  });

  final double bmi;
  final double? targetBmi;

  Color getColorFromLinearGradient({
    required LinearGradient gradient,
    required double t, // from 0.0 to 1.0
  }) {
    assert(t >= 0.0 && t <= 1.0);

    final stops =
        gradient.stops ??
        List.generate(
          gradient.colors.length,
          (i) => i / (gradient.colors.length - 1),
        );

    for (int i = 0; i < stops.length - 1; i++) {
      final double start = stops[i];
      final double end = stops[i + 1];

      if (t >= start && t <= end) {
        final localT = (t - start) / (end - start);
        return Color.lerp(gradient.colors[i], gradient.colors[i + 1], localT)!;
      }
    }

    return gradient.colors.last;
  }

  @override
  Widget build(BuildContext context) {
    bool targetExists = targetBmi != null;
    Color arrowColor;
    final underWeightGradient = LinearGradient(
      colors: [
        Color(0xFF604BFF),
        Color(0xFF4BA5FF),
        Color(0xFF76FD8F),
      ],
    );
    final normalWeightGradient = LinearGradient(
      colors: [
        Color(0xFF47FF6F),
        Color(0xFF00C32A),
        Color(0xFFBBFF3C),
      ],
    );
    final overWeightGradient = LinearGradient(
      colors: [
        Color(0xFFE3FF43),
        Color(0xFFFBFF29),
        Color(0xFFFFA718),
      ],
    );
    final obeseGradient = LinearGradient(
      colors: [
        Color(0xFFFF8922),
        Color(0xFFFF0000),
      ],
    );
    if (bmi < 18.5) {
      arrowColor = getColorFromLinearGradient(
        gradient: underWeightGradient,
        t: (bmi - 13.5) / 5,
      );
    } else if (bmi < 25.0) {
      arrowColor = getColorFromLinearGradient(
        gradient: normalWeightGradient,
        t: (bmi - 18.5) / 6.5,
      );
    } else if (bmi < 30.0) {
      arrowColor = getColorFromLinearGradient(
        gradient: overWeightGradient,
        t: (bmi - 25) / 5,
      );
    } else {
      arrowColor = getColorFromLinearGradient(
        gradient: obeseGradient,
        t: (bmi - 30) / 5,
      );
    }

    int rightBmiFlex = ((35 - bmi) * 10).round();
    int leftBmiFlex = ((bmi - 13.5) * 10).round();

    int rightTargetBmiFlex = 0;
    int leftTargetBmiFlex = 0;

    if (targetExists) {
      rightTargetBmiFlex = ((35 - targetBmi!) * 10).round();
      leftTargetBmiFlex = ((targetBmi! - 13.5) * 10).round();
    }

    return Column(
      children: [
        Stack(
          children: [
            targetExists
                ? Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: leftTargetBmiFlex,
                        child: SizedBox(),
                      ),
                      Text(
                        "▽",
                        style: TextStyle(
                          color: AppPalette.outlineEnabled,
                          fontSize: 15,
                        ),
                      ),
                      Expanded(
                        flex: rightTargetBmiFlex,
                        child: SizedBox(),
                      ),
                    ],
                  )
                : SizedBox(),
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: leftBmiFlex,
                  child: SizedBox(),
                ),
                Text(
                  "▼",
                  style: TextStyle(color: arrowColor),
                ),
                Expanded(
                  flex: rightBmiFlex,
                  child: SizedBox(),
                ),
              ],
            ),
          ],
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            // Blue to Green (rounded start)
            Expanded(
              flex: 50,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  gradient: underWeightGradient,
                ),
              ),
            ),

            // Black vertical divider
            Container(width: 2, height: 6, color: Colors.black),

            // Green to Yellow
            Expanded(
              flex: 64,
              child: Container(
                height: 6,
                color: null,
                decoration: BoxDecoration(
                  gradient: normalWeightGradient,
                ),
              ),
            ),

            Container(width: 2, height: 6, color: Colors.black),

            // Yellow to Orange
            Expanded(
              flex: 50,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  gradient: overWeightGradient,
                ),
              ),
            ),

            Container(width: 2, height: 6, color: Colors.black),

            // Orange to Red (rounded end)
            Expanded(
              flex: 50,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  gradient: obeseGradient,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
