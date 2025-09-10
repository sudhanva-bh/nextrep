import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/core/common/providers.dart';
import 'package:nextrep/core/entities/workout/workout.dart';
import 'package:nextrep/features/home/presentation/widgets/favourite_workouts/favourite_workouts_tiles.dart';

class FavouriteWorkouts extends ConsumerWidget {
  const FavouriteWorkouts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<List<Workout>>(
      valueListenable: ref.read(workoutsServiceProvider).getFavouriteWorkoutsListenable(),
      builder: (context, favouriteExercises, _) {
        if (favouriteExercises.isEmpty) {
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
              const SizedBox(height: 12),
              Text(
                "No favourites added yet",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ); // or show "No favourites yet"
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Favourites",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: List.generate(favouriteExercises.length, (n) {
                return Column(
                  children: [
                    FavouriteWorkoutsTiles(
                      workout: favouriteExercises[n],
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
