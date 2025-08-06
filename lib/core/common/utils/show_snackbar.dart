import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Center(child: Text(content)),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  });
}
