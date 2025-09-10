import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextrep/core/common/providers.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/workout/workout.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_with_inkwell.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/home/presentation/widgets/favourite_workouts/folder.dart';
import 'package:nextrep/features/preview_workout/presentation/pages/preview_workout.dart';

class FavouriteWorkoutsTiles extends ConsumerWidget {
  const FavouriteWorkoutsTiles({super.key, required this.workout});
  final Workout workout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigateWithInkwell(
      destination: PreviewWorkout(workoutListenable: ref.read(workoutsServiceProvider).workoutListenable(workout.workoutName)),
      child: Container(
        width: double.infinity,
        height: 176,
        decoration: BoxDecoration(
          boxShadow: WidgetProperties.dropShadow,
          color: AppPalette.surface,
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: AssetImage(workout.imagePath),
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            FavouriteFolder(
              height: 90,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.dumbbell,
                          color: AppPalette.onSurface,
                        ),
                        SizedBox(width: 18),
                        SizedBox(
                          width: 110,
                          child: Text(
                            workout.workoutName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppPalette.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${workout.exercises.length} exercises",
                      style: TextStyle(color: AppPalette.notSelected),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
