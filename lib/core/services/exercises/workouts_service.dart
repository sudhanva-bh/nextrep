import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nextrep/core/data/preset_workouts.dart';
import 'package:nextrep/core/entities/workout/workout.dart';

class WorkoutsService {
  final box = Hive.box<Workout>('workoutsBox');

  /* --------------------- Get Workouts --------------------- */

  /// Get a single workout by name
  Workout? getWorkout(String workoutName) {
    return box.get(workoutName);
  }

  /// Get all saved workouts
  List<Workout> getAllWorkouts() {
    return box.values.toList();
  }

  /// Search workouts by name (case insensitive)
  List<Workout> searchWorkouts(String query) {
    final lowerQuery = query.toLowerCase();
    return box.values
        .where(
          (workout) => workout.workoutName.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  /* --------------------- Update Workouts --------------------- */

  /// Update a single workout (overwrite if exists)
  Future<void> updateWorkout(Workout workout) async {
    await box.put(workout.workoutName, workout);
  }

  /// Upload a new workout only if it doesn’t already exist
  Future<void> uploadNewWorkout(Workout workout) async {
    if (!box.containsKey(workout.workoutName)) {
      await box.put(workout.workoutName, workout);
    }
  }

  /// Bulk update workouts
  Future<void> updateAllWorkouts(List<Workout> workouts) async {
    final Map<String, Workout> entriesToUpdate = {
      for (var workout in workouts) workout.workoutName: workout,
    };

    await box.putAll(entriesToUpdate);
  }

  /* --------------------- Preset Workouts --------------------- */

  /// Save preset workouts if none exist
  Future<void> putPresetWorkouts() async {
    if (box.isEmpty) {
      for (final workout in PresetWorkouts.workouts) {
        await box.put(workout.workoutName, workout);
      }
      debugPrint('✅ Preset Workouts cached in Hive');
    } else {
      debugPrint('📦 Preset Workouts already cached');
    }
  }

  /// Delete all workouts
  Future<void> deleteAllWorkouts() async {
    await box.clear();
  }

  /* --------------------- Reactivity --------------------- */

  /// Listen to changes for a single workout
  ValueListenable<Workout?> workoutListenable(String workoutName) {
    return box.listenable(keys: [workoutName]).map((_) => box.get(workoutName));
  }

  /// Listen to changes for all workouts
  ValueListenable<List<Workout>> getAllWorkoutsListenable() {
    return box.listenable().map((_) => box.values.toList());
  }

  /* --------------------- Favourites --------------------- */

  /// Listen to favourite workouts
  ValueListenable<List<Workout>> getFavouriteWorkoutsListenable() {
    return box.listenable().map(
          (_) => box.values.where((workout) => workout.isFavourite).toList(),
        );
  }

  /// Mark a workout as favourite
  Future<void> addFavourite(String workoutName) async {
    final workout = box.get(workoutName);
    if (workout != null) {
      final updated = workout.copyWith(isFavourite: true);
      await box.put(workoutName, updated);
    }
  }

  /// Remove a workout from favourites
  Future<void> removeFavourite(String workoutName) async {
    final workout = box.get(workoutName);
    if (workout != null && workout.isFavourite) {
      final updated = workout.copyWith(isFavourite: false);
      await box.put(workoutName, updated);
    }
  }

  /// Save preset favourite workouts (first-time setup)
  Future<void> putPresetFavouriteWorkouts() async {
    if (box.isEmpty) {
      for (final workout in PresetWorkouts.favourites) {
        await box.put(workout.workoutName, workout.copyWith(isFavourite: true));
      }
      debugPrint('✅ Preset Favourite Workouts cached in Hive');
    } else {
      debugPrint('📦 Preset Favourite Workouts already cached');
    }
  }

  /// Remove all favourites (reset)
  Future<void> deleteAllFavouriteWorkouts() async {
    for (final workout in box.values) {
      if (workout.isFavourite) {
        await box.put(
          workout.workoutName,
          workout.copyWith(isFavourite: false),
        );
      }
    }
  }
}

/* --------------------- Helper Extension --------------------- */

/// Extension to transform a ValueListenable into another type
extension MapListenable<T> on ValueListenable {
  ValueListenable<R> map<R>(R Function(T) convert) {
    final notifier = ValueNotifier<R>(convert(value));
    addListener(() {
      notifier.value = convert(value);
    });
    return notifier;
  }
}
