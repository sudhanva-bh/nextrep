import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/workout/workout.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/home/presentation/widgets/favourite_workouts/folder.dart';

class FavouriteWorkoutsTiles extends StatelessWidget {
  const FavouriteWorkoutsTiles({super.key, required this.workout});
  final Workout workout;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              // child: Column(
              //   children: [
              //     Row(
              //       children: [
              //         Container(
              //           padding: EdgeInsets.all(6),
              //           decoration: BoxDecoration(
              //             color: AppPalette.lightSurface,
              //             borderRadius: BorderRadius.circular(100),
              //             boxShadow: WidgetProperties.dropShadow,
              //           ),

              //           child: Center(
              //             child: Icon(
              //               Icons.fitness_center,
              //               size: 24,
              //             ),
              //           ),
              //         ),
              //         SizedBox(width: 14),
              //         Text(
              //           "Today's\nWorkout",
              //           style: TextStyle(
              //             fontSize: 17,
              //             height: 1.16,
              //             letterSpacing: 0.06,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ],
              //     ),
              //     SizedBox(height: 25),
              //   ],
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
