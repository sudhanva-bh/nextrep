import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';
import 'package:nextrep/core/entities/workout/exercise_set.dart';
import 'package:nextrep/core/entities/workout/workout.dart';

class FavouriteWorkoutsHiveSync {
  static Future<void> favouriteWorkoutModelsToHive() async {
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ExerciseSetAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ExerciseSessionAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(WorkoutAdapter());
    }
    await Hive.openBox<Workout>('favouriteWorkoutsBox');
    debugPrint(
      '✅ FavouriteWorkouts Model registered and box opened in Hive',
    );
  }
}
