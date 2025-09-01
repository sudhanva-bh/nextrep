import 'package:flutter/material.dart';

class NavigateWithInkwell extends StatelessWidget {
  final Widget destination;
  final Widget child;
  final double borderRadius;
  final Duration delay;

  const NavigateWithInkwell({
    super.key,
    required this.child,
    required this.destination,
    this.borderRadius = 12,
    this.delay = const Duration(milliseconds: 150), // default delay
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () async {
          await Future.delayed(delay);
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => destination),
            );
          }
        },
        child: child,
      ),
    );
  }
}
