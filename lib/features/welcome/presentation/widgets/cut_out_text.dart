import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

/// A widget that displays text with a cut-out effect inside a rounded rectangle background.
class CutOutText extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextDirection textDirection;
  final double boxRadius;
  final Color boxBackgroundColor;
  final EdgeInsets padding;
  final int duration;

  const CutOutText({
    super.key,
    required this.text,
    this.fontSize = 40.0,
    this.textDirection = TextDirection.ltr,
    this.boxRadius = 200,
    this.boxBackgroundColor = AppPalette.inverseSurface,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.duration = 400,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
    // Measure the text
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: textDirection,
    )..layout();

    final width = textPainter.width + padding.horizontal;
    final height = textPainter.height + padding.vertical;

    return AnimatedContainer(
      width: width,
      height: height,
      duration: Duration(milliseconds: duration),
      curve: Curves.fastOutSlowIn,
      child: Center(
        child: SizedBox(
          height: height,
          width: width,
          child: CustomPaint(
            painter: _CutOutTextPainter(
              text: text,
              textStyle: textStyle,
              textDirection: textDirection,
              boxRadius: boxRadius,
              boxBackgroundColor: boxBackgroundColor,
              padding: padding,
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal painter for the cut-out effect.
class _CutOutTextPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;
  final TextDirection textDirection;
  final double boxRadius;
  final Color boxBackgroundColor;
  final EdgeInsets padding;

  late final TextPainter _textPainter;

  _CutOutTextPainter({
    required this.text,
    required this.textStyle,
    required this.textDirection,
    required this.boxRadius,
    required this.boxBackgroundColor,
    required this.padding,
  }) {
    _textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: textDirection,
    )..layout();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final textOffset = Offset(padding.left, padding.top);
    final boxRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(boxRadius),
    );

    final boxPaint = Paint()
      ..color = boxBackgroundColor
      ..blendMode = BlendMode.srcOut;

    canvas.saveLayer(boxRect.outerRect, Paint());

    _textPainter.paint(canvas, textOffset);
    canvas.drawRRect(boxRect, boxPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CutOutTextPainter oldDelegate) {
    return text != oldDelegate.text ||
        textStyle != oldDelegate.textStyle ||
        textDirection != oldDelegate.textDirection ||
        boxRadius != oldDelegate.boxRadius ||
        boxBackgroundColor != oldDelegate.boxBackgroundColor ||
        padding != oldDelegate.padding;
  }
}
