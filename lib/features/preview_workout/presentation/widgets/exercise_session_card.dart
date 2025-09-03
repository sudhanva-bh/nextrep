import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class ExerciseSessionCard extends StatelessWidget {
  const ExerciseSessionCard({
    super.key,
    required this.exercise,
    required this.exerciseSession,
  });

  final Exercise exercise;
  final ExerciseSession exerciseSession;

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 110,
      decoration: BoxDecoration(
        color: AppPalette.surface,
        boxShadow: WidgetProperties.dropShadow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(12),
              child: Image.asset(exercise.image0),
            ),
            SizedBox(width: 6),
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(12),
              child: Image.asset(exercise.image1),
            ),
            SizedBox(
              width: 20,
              child: VerticalDivider(),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: TextStyle(
                      color: AppPalette.onSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.5),
                  Text(
                    "${exerciseSession.sets[0].weight} kgs",
                    style: TextStyle(
                      fontSize: 11,
                      color: AppPalette.lighterSurface,
                      height: 1.3,
                    ),
                  ),
                  Text(
                    "${exerciseSession.sets.length} sets | ${exerciseSession.sets[0].reps} reps",
                    style: TextStyle(
                      fontSize: 11,
                      color: AppPalette.lighterSurface,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
