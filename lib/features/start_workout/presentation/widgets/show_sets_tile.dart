// In: features/start_workout/presentation/widgets/show_sets_tile.dart

import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/workout/exercise_set.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/start_workout/presentation/widgets/reps_number_input_card.dart';

class ShowSetsTile extends StatelessWidget {
  const ShowSetsTile({
    super.key,
    required this.exerciseSet,
    required this.setIndex,
    required this.isDone,
    required this.onToggle,
    required this.onUpdate,
  });

  final ExerciseSet exerciseSet;
  final int setIndex;
  final bool isDone;
  final VoidCallback onToggle;
  final Function(int reps, double weight) onUpdate;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isDone
            ? AppPalette.primary.withAlpha(155)
            : AppPalette.lightSurface,
        boxShadow: WidgetProperties.subtleDropShadow,
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(milliseconds: 200),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Checkbox(
            value: isDone,
            onChanged: (bool? value) => onToggle(),
            activeColor: AppPalette.primary,
          ),
          Row(
            children: [
              const Text("Reps"),
              RepsNumberInputCard(
                initialValue: exerciseSet.reps.toString(),
                onChanged: (reps) => onUpdate(reps.toInt(), exerciseSet.weight),
                isDone: isDone,
              ),
              SizedBox(width: 12),
              const Text("Weight"),
              RepsNumberInputCard(
                initialValue: exerciseSet.weight.toStringAsFixed(1),
                onChanged: (weight) => onUpdate(exerciseSet.reps, weight),
                isDecimal: true,
                isDone: isDone,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
