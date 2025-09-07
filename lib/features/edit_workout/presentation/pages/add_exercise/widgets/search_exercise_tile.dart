import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_run_function.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/preview_workout/presentation/utils/bottom_workout_preview_popup.dart';

class SearchExerciseTile extends StatelessWidget {
  const SearchExerciseTile({
    super.key,
    required this.exercise,
    required this.onAdd,
  });

  final Exercise exercise;
  final Function onAdd;

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
    return NavigateRunFunction(
      onTap: () => BottomWorkoutPreviewPopup.showPopup(
        context,
        exercise,
      ),
      child: Container(
        key: ValueKey(exercise.id),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: AppPalette.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: WidgetProperties.dropShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      exercise.image0,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${capitalize(exercise.bodyPart)} | ${capitalize(exercise.targetMuscle)}",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppPalette.onSurface.withAlpha(190),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.dumbbell,
                              size: 12,
                            ),
                            SizedBox(width: 6),
                            Text(
                              capitalize(exercise.equipment),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppPalette.onSurface.withAlpha(190),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  NavigateRunFunction(
                    onTap: () {
                      onAdd();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppPalette.lightSurface,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // ListTile(
    //   title: Text(exercise.name),
    //   subtitle: Text(exercise.targetMuscle),
    //   trailing: IconButton(
    //     icon: const Icon(
    //       Icons.add_circle_outline,
    //       color: AppPalette.primary,
    //     ),
    //     onPressed: () => print('Added ${exercise.name}'),
    //   ),
    // );
  }
}
