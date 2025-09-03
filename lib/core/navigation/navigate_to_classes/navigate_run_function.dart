import 'package:flutter/material.dart';

class NavigateRunFunction extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Duration delay;

  const NavigateRunFunction({
    super.key,
    required this.child,
    required this.onTap,
    this.delay = Duration.zero, // default = no delay
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (delay > Duration.zero) {
          await Future.delayed(delay);
        }
        onTap();
      },
      highlightColor: Colors.transparent,
      child: child,
    );
  }
}
