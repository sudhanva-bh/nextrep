import 'package:flutter/material.dart';

class NavigateWithFadeNoBack {
  final Widget navigateTo;
  final BuildContext context;

  NavigateWithFadeNoBack(
    this.context,
    this.navigateTo,
  ) {
    Navigator.of(context).pushReplacement(
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
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }
}
