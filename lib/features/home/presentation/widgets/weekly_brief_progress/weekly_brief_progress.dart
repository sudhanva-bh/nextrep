import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/home/presentation/widgets/weekly_brief_progress/weekly_item.dart';

class WeeklyBriefProgress extends StatelessWidget {
  const WeeklyBriefProgress({super.key});

  String weekdayName(int weekday) {
    const names = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return names[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final last6Days = List.generate(6, (index) {
      final day = today.subtract(
        Duration(days: 5 - index),
      );
      return weekdayName(day.weekday);
    });
    final weekWidgetList = List.generate(6, (index) {
      return WeeklyItem(week: last6Days[index], isDone: index < 4);
    });

    return Container(
      height: 78,
      decoration: BoxDecoration(
        boxShadow: WidgetProperties.dropShadow,
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: weekWidgetList,
      ),
    );
  }
}
