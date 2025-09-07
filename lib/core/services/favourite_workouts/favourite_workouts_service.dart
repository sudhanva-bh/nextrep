import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nextrep/core/data/preset_workouts.dart';
import 'package:nextrep/core/entities/workout/workout.dart';

class FavouriteWorkoutsService {
  final box = Hive.box<Workout>('favouriteWorkoutsBox');

  /// Retrieves a single [Workout] from Hive by its [workoutName].
  Workout? getWorkout(String workoutName) {
    return box.get(workoutName);
  }

  /// Returns a list of all stored [Workout]s from Hive.
  List<Workout> getAllWorkouts() {
    return box.values.toList();
  }

  /// Searches and returns a list of [Workout]s whose names
  /// contain the given [query] (case-insensitive).
  List<Workout> searchWorkouts(String query) {
    final lowerQuery = query.toLowerCase();
    return box.values
        .where(
          (workout) => workout.workoutName.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  /// Updates an existing [Workout] in Hive.
  /// If the workout does not exist, this will add it as new.
  Future<void> updateWorkout(Workout workout) async {
    await box.put(workout.workoutName, workout);
  }

  /// Uploads a new [Workout] to Hive if it doesn't already exist.
  Future<void> uploadNewWorkout(Workout workout) async {
    if (!box.containsKey(workout.workoutName)) {
      await box.put(workout.workoutName, workout);
    }
  }

  /// Updates or inserts multiple [Workout]s at once.
  Future<void> updateAllWorkouts(List<Workout> workouts) async {
    final Map<String, Workout> entriesToUpdate = {
      for (var workout in workouts) workout.workoutName: workout,
    };

    await box.putAll(entriesToUpdate);
  }

  Future<void> putPresetWorkouts() async {
    if (box.isEmpty) {
      for (final workout in PresetWorkouts.favourites) {
        await box.put(workout.workoutName, workout);
      }
      debugPrint('✅ Preset Favourite Workouts cached in Hive');
    } else {
      debugPrint('📦 Preset Favourite Workouts already cached');
    }
  }

  Future<void> deleteAllWorkouts() async {
    await box.clear();
  }

  /// Listen to a specific [Workout] by name.
  ValueListenable<Workout?> workoutListenable(String workoutName) {
    return box
        .listenable(keys: [workoutName])
        .map(
          (_) => box.get(workoutName),
        );
  }

  /// Returns a [ValueListenable] that rebuilds whenever
  /// the list of favourite workouts changes.
  ValueListenable<List<Workout>> getAllWorkoutsListenable() {
    return box.listenable().map((_) => box.values.toList());
  }
}

/// Small extension to transform a [ValueListenable<T>] into another type
extension MapListenable<T> on ValueListenable<T> {
  ValueListenable<R> map<R>(R Function(T) convert) {
    final notifier = ValueNotifier<R>(convert(value));
    addListener(() {
      notifier.value = convert(value);
    });
    return notifier;
  }
}
