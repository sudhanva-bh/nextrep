import 'package:flutter/material.dart';
import 'package:nextrep/core/entities/workout/exercise_set.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/edit_workout/presentation/widgets/number_input_card.dart';

class SetsEditTile extends StatefulWidget {
  const SetsEditTile({
    super.key,
    required this.exerciseSet,
    required this.onUpdate,
  });

  final ExerciseSet exerciseSet;
  final Function(int reps, double weight) onUpdate;

  @override
  State<SetsEditTile> createState() => _SetsEditTileState();
}

class _SetsEditTileState extends State<SetsEditTile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppPalette.lightSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 64,
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Reps"),
                SizedBox(width: 8),
                NumberInputCard(
                  initialValue: widget.exerciseSet.reps.toString(),
                  onChanged: (reps) =>
                      widget.onUpdate(reps.toInt(), widget.exerciseSet.weight),
                ),
              ],
            ),
          ),
          VerticalDivider(
            color: AppPalette.outlineEnabled,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Weight"),
                SizedBox(width: 4),
                Row(
                  children: [
                    NumberInputCard(
                      initialValue: widget.exerciseSet.weight.toString(),
                      isDecimal: true,
                      onChanged: (weight) =>
                          widget.onUpdate(widget.exerciseSet.reps, weight),
                    ),
                    Text(
                      "KGs",
                      style: TextStyle(
                        fontSize: 9,
                        color: AppPalette.lighterSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
