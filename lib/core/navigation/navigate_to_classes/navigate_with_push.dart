import 'package:flutter/material.dart';

class NavigateWithPush {
  final Widget navigateTo;
  final BuildContext context;

  NavigateWithPush(
    this.context,
    this.navigateTo,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return navigateTo;
        },
        transitionsBuilder:
            (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
