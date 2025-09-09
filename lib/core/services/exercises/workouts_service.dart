import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nextrep/core/data/preset_workouts.dart';
import 'package:nextrep/core/entities/workout/workout.dart';

class WorkoutsService {
  final box = Hive.box<Workout>('workoutsBox');

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
    print(box.get(workout.workoutName));
    await box.put(workout.workoutName, workout);
    print("Updated: ${box.get(workout.workoutName)}");
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
      for (final workout in PresetWorkouts.workouts) {
        await box.put(workout.workoutName, workout);
      }
      debugPrint('✅ Preset Workouts cached in Hive');
    } else {
      debugPrint('📦 Preset Workouts already cached');
    }
  }

  Future<void> deleteAllWorkouts() async {
    await box.clear();
  }

  ValueListenable<Workout?> workoutListenable(String workoutName) {
    // Wrap it in a MapValueListenableBuilder so we only listen to that key
    return box.listenable(keys: [workoutName]).map((_) => box.get(workoutName));
  }

  ValueListenable<List<Workout>> getAllWorkoutsListenable() {
    return box.listenable().map((_) => box.values.toList());
  }
}

// Small extension to map a ValueListenable<T> to another type
extension MapListenable<T> on ValueListenable {
  ValueListenable<R> map<R>(R Function(T) convert) {
    final notifier = ValueNotifier<R>(convert(value));
    addListener(() {
      notifier.value = convert(value);
    });
    return notifier;
  }
}
