import 'package:flutter/material.dart';
import 'package:nextrep/core/entities/workout/workout.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';
import 'package:nextrep/core/services/exercises/workouts_service.dart';

class EditWorkout extends StatelessWidget {
  const EditWorkout({super.key, required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Workout (Test)"),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            if (workout.exercises.length >= 2) {
              // Copy list and swap index 0 and 1
              final newExercises = List<ExerciseSession>.from(
                workout.exercises,
              );
              final temp = newExercises[0];
              newExercises[0] = newExercises[1];
              newExercises[1] = temp;

              // Use copyWith to create updated workout
              final updatedWorkout = workout.copyWith(exercises: newExercises);
              WorkoutsService().updateWorkout(updatedWorkout);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Not enough exercises to swap")),
              );
            }
          },
          icon: const Icon(Icons.swap_vert),
          label: const Text("Swap First Two Exercises"),
        ),
      ),
    );
  }
}
