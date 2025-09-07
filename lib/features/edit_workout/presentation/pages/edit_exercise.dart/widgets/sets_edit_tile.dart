import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/workout/exercise_set.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/edit_workout/presentation/pages/edit_exercise.dart/widgets/number_input_card.dart';

class SetsEditTile extends StatefulWidget {
  const SetsEditTile({
    super.key,
    required this.exerciseSet,
    required this.onUpdate,
    required this.onDelete,
  });

  final ExerciseSet exerciseSet;
  final Function(int reps, double weight) onUpdate;
  final Function onDelete;

  @override
  State<SetsEditTile> createState() => _SetsEditTileState();
}

class _SetsEditTileState extends State<SetsEditTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.exerciseSet.hashCode),
      direction: DismissDirection.horizontal,
      background: Container(
        decoration: BoxDecoration(
          color: AppPalette.error,
          borderRadius: BorderRadius.circular(12),
          boxShadow: WidgetProperties.subtleDropShadow,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: AppPalette.onError),
      ),
      onDismissed: (_) => widget.onDelete(),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: AppPalette.lightSurface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: WidgetProperties.subtleDropShadow,
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
                    onChanged: (reps) => widget.onUpdate(
                      reps.toInt(),
                      widget.exerciseSet.weight,
                    ),
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
      ),
    );
  }
}
