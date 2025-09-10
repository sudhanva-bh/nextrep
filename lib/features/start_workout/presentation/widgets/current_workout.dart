import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/preview_workout/data/fetch_target_part_images.dart';
import 'package:nextrep/features/start_workout/presentation/widgets/show_sets_tile.dart';

class CurrentWorkout extends StatelessWidget {
  const CurrentWorkout({
    super.key,
    required this.exercise,
    required this.exerciseSession,
    required this.onToggle,
    required this.setsDone,
    // The onReorder callback is removed
    required this.onAddSet,
    required this.onDeleteSet,
    required this.onUpdateSet,
  });

  final Exercise exercise;
  final ExerciseSession exerciseSession;
  final Function(int) onToggle;
  final List<bool> setsDone;
  final VoidCallback onAddSet;
  final Function(int setIndex) onDeleteSet;
  final Function(int setIndex, int reps, double weight) onUpdateSet;

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        boxShadow: WidgetProperties.dropShadow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            "Current Exercise",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              color: AppPalette.lighterSurface,
              thickness: 2,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              MuscleApiService().getMuscleImageBuilderForExercise(
                exercise,
                height: 160,
                width: 160,
              ),
              const SizedBox(width: 12), // spacing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Divider(thickness: 2, color: AppPalette.lighterSurface),

                    // Equipment
                    Row(
                      children: [
                        const Icon(FontAwesomeIcons.dumbbell, size: 12),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Equipment: ${capitalize(exercise.equipment)}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1),

                    // Target
                    Row(
                      children: [
                        const Icon(FontAwesomeIcons.dumbbell, size: 12),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Target: ${capitalize(exercise.targetMuscle)}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1),

                    // Secondary
                    Row(
                      children: [
                        const Icon(FontAwesomeIcons.dumbbell, size: 12),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Secondary: ${exercise.secondaryMuscles.map((e) => capitalize(e)).join(", ")}",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ✨ Replaced ReorderableListView with a Column
          Column(
            children: [
              for (int index = 0; index < exerciseSession.sets.length; index++)
                Dismissible(
                  key: ValueKey(exerciseSession.sets[index].hashCode),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) => onDeleteSet(index),
                  background: Container(
                    decoration: BoxDecoration(
                      color: AppPalette.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: AppPalette.onError),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ShowSetsTile(
                      exerciseSet: exerciseSession.sets[index],
                      setIndex: index,
                      isDone: setsDone[index],
                      onToggle: () => onToggle(index),
                      onUpdate: (reps, weight) =>
                          onUpdateSet(index, reps, weight),
                    ),
                  ),
                ),
              Center(
                child: TextButton(
                  onPressed: onAddSet,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "+ Add Set",
                      style: TextStyle(
                        color: AppPalette.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
