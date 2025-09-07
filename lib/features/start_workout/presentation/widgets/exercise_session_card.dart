import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_run_function.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/preview_workout/presentation/utils/bottom_workout_preview_popup.dart';

class StartExerciseSessionCard extends StatelessWidget {
  const StartExerciseSessionCard({
    super.key,
    required this.exercise,
    required this.exerciseSession,
    required this.isDone,
    required this.onToggle,
    required this.isSelected,
  });

  final Exercise exercise;
  final ExerciseSession exerciseSession;
  final bool isDone, isSelected;
  final Function onToggle;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.all(14.0),
      height: 110,
      decoration: BoxDecoration(
        color: isDone
            ? AppPalette.primary.withAlpha(155)
            : isSelected
            ? AppPalette.primary.withAlpha(30)
            : AppPalette.surface,
        boxShadow: WidgetProperties.dropShadow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected
              ? AppPalette.primary.withAlpha(155)
              : AppPalette.transparent,
        ),
      ),
      duration: Duration(milliseconds: 100),
      child: Row(
        children: [
          NavigateRunFunction(
            onTap: () {
              BottomWorkoutPreviewPopup.showPopup(
                context,
                exercise,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(12),
              child: Image.asset(exercise.image0),
            ),
          ),
          SizedBox(width: 6),
          NavigateRunFunction(
            onTap: () {
              BottomWorkoutPreviewPopup.showPopup(
                context,
                exercise,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(12),
              child: Image.asset(exercise.image1),
            ),
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
                    color: AppPalette.onSurface,
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
                    color: AppPalette.onSurface.withAlpha(isDone ? 255 : 155),
                    height: 1.3,
                  ),
                ),
                Text(
                  "${exerciseSession.sets.length} sets | ${exerciseSession.sets[0].reps} reps",
                  style: TextStyle(
                    fontSize: 11,
                    color: AppPalette.onSurface.withAlpha(isDone ? 255 : 155),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: isDone,
            onChanged: (bool? value) => onToggle(),
            activeColor: AppPalette.primary,
          ),
        ],
      ),
    );
  }
}
