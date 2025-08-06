import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nextrep/core/data/preset_workouts.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';
import 'package:nextrep/core/entities/workout/exercise_set.dart';
import 'package:nextrep/core/entities/workout/workout.dart';

class ExerciseModelHiveSync {
  static Future<void> exerciseModelsToHive() async {
    Hive.registerAdapter(ExerciseSetAdapter());
    Hive.registerAdapter(ExerciseSessionAdapter());
    Hive.registerAdapter(WorkoutAdapter());

    final box = await Hive.openBox<Workout>('workoutsBox');

    if (box.isEmpty) {
      for (final workout in PresetWorkouts.workouts) {
        await box.put(workout.workoutName, workout);
      }
      debugPrint('✅ Preset Workouts cached in Hive');
    } else {
      debugPrint('📦 Preset Workouts already cached');
    }
  }
}
