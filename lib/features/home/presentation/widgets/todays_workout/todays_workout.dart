import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/workout/workout.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/home/presentation/widgets/todays_workout/exercise_card.dart';
import 'package:nextrep/features/home/presentation/widgets/todays_workout/folder.dart';

class TodaysWorkout extends StatelessWidget {
  final Workout workout;

  const TodaysWorkout({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 476,
      decoration: BoxDecoration(
        boxShadow: WidgetProperties.dropShadow,
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: AssetImage(workout.imagePath),
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Folder(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppPalette.lightSurface,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: WidgetProperties.dropShadow,
                        ),

                        child: Center(
                          child: Icon(
                            Icons.fitness_center,
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: 14),
                      Text(
                        "Today's\nWorkout",
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.16,
                          letterSpacing: 0.06,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: ExerciseCard(exercise: workout.exercises[0]),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ExerciseCard(exercise: workout.exercises[1]),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ExerciseCard(exercise: workout.exercises[2]),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ExerciseCard(exercise: workout.exercises[3]),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ExerciseCard(exercise: workout.exercises[4]),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ExerciseCard(exercise: workout.exercises[5]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
