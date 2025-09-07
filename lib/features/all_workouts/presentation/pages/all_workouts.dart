import 'package:flutter/material.dart';
import 'package:nextrep/core/entities/workout/workout.dart';
import 'package:nextrep/core/services/exercises/workouts_service.dart';
import 'package:nextrep/features/home/presentation/widgets/favourite_workouts/favourite_workouts_tiles.dart';

class AllWorkouts extends StatelessWidget {
  const AllWorkouts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Workouts",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: ValueListenableBuilder<List<Workout>>(
        valueListenable: WorkoutsService().getAllWorkoutsListenable(),
        builder: (context, favouriteExercises, _) {
          if (favouriteExercises.isEmpty) {
            return const SizedBox.shrink(); // or show "No favourites yet"
          }

          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
