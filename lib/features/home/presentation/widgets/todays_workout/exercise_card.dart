import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/core/common/providers.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_run_function.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/preview_workout/presentation/utils/bottom_workout_preview_popup.dart';

class ExerciseCard extends ConsumerWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
  });
  final ExerciseSession exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchedExercise = ref
        .read(exerciseServiceProvider)
        .getExerciseById(
          exercise.workoutId,
        );
    return NavigateRunFunction(
      onTap: () {
        BottomWorkoutPreviewPopup.showPopup(context, fetchedExercise);
      },
      child: Container(
        padding: EdgeInsets.all(11),
        height: 66,

        decoration: BoxDecoration(
          color: AppPalette.lightSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                fetchedExercise.image0,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 6),
            Text(
              "x${exercise.sets.length}",
              style: TextStyle(
                color: AppPalette.onSurface.withAlpha(200),
                fontSize: 10,
              ),
            ),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                fetchedExercise.nickname ?? fetchedExercise.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
