import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class ExerciseTimer extends StatefulWidget {
  final DateTime startTime; // e.g. DateTime.now() or some fixed time

  const ExerciseTimer({super.key, required this.startTime});

  @override
  State<ExerciseTimer> createState() => _ExerciseTimerState();
}

class _ExerciseTimerState extends State<ExerciseTimer> {
  late Timer _timer;
  String _formattedTime = "00:00:00";

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    final elapsed = now.difference(widget.startTime);
    setState(() {
      _formattedTime = _formatDuration(elapsed);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppPalette.lightSurface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: WidgetProperties.subtleDropShadow,
      ),
      child: Text(
        _formattedTime,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
