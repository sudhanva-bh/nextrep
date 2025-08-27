import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';
import 'package:nextrep/core/entities/workout/exercise_set.dart';
import 'package:nextrep/core/entities/workout/workout.dart';

class ExerciseModelHiveSync {
  static Future<void> exerciseModelsToHive() async {
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(ExerciseSetAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(ExerciseSessionAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(WorkoutAdapter());
    }

    await Hive.openBox<Workout>('workoutsBox');

    debugPrint('✅ Workout Model registered and \'workoutsBox\' opened in Hive');
  }
}
