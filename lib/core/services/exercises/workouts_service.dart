// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:nextrep/core/common/utils/show_snackbar.dart';
import 'package:nextrep/core/entities/workout/workout.dart';

class WorkoutsService {
  final BuildContext context;
  WorkoutsService({required this.context});

  final box = Hive.box<Workout>('workoutsBox');

  Workout? getWorkout(String workoutName) {
    return box.get(workoutName);
  }

  List<Workout> getAllWorkouts() {
    return box.values.toList();
  }

  List<Workout> searchWorkouts(String query) {
    final lowerQuery = query.toLowerCase();
    return box.values
        .where(
          (workout) => workout.workoutName.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  Future<void> syncWorkout(Workout workout) async {
    await box.put(workout.workoutName, workout);
  }

  Future<void> uploadNewWorkout(Workout workout) async {
    if (box.containsKey(workout.workoutName)) {
      showSnackBar(context, "Workout ${workout.workoutName} Already Exists");
    } else {
      await box.put(workout.workoutName, workout);
      if (context.mounted) {
        showSnackBar(context, "Updated ${workout.workoutName} Successfully");
      }
    }
  }
}
