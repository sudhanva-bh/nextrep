import 'package:flutter/material.dart';
import 'package:nextrep/core/entities/workout/workout.dart';
import 'package:nextrep/core/services/favourite_workouts/favourite_workouts_service.dart';
import 'package:nextrep/features/home/presentation/widgets/favourite_workouts/favourite_workouts_tiles.dart';

class FavouriteWorkouts extends StatelessWidget {
  FavouriteWorkouts({
    super.key,
  });

  final List<Workout> favouriteExercises = FavouriteWorkoutsService()
      .getAllWorkouts();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Favourites",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Column(
          children: List.generate(favouriteExercises.length, (n) {
            return Column(
              children: [
                FavouriteWorkoutsTiles(
                  workout: favouriteExercises[n],
                ),
                SizedBox(height: 8),
              ],
            );
          }),
        ),
      ],
    );
  }
}
