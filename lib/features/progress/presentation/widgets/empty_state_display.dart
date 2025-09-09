import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class EmptyStateDisplay extends StatelessWidget {
  final String message;
  const EmptyStateDisplay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Progress'),
        backgroundColor: AppPalette.background,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.monitor_heart_outlined,
                size: 80,
                color: AppPalette.primary,
              ),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppPalette.onSurface,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}