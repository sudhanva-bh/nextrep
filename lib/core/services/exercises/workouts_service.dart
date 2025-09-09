import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nextrep/core/data/preset_workouts.dart';
import 'package:nextrep/core/entities/workout/workout.dart';

class WorkoutsService {
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

  Future<void> updateWorkout(Workout workout) async {
    await box.put(workout.workoutName, workout);
  }

  Future<void> uploadNewWorkout(Workout workout) async {
    if (!box.containsKey(workout.workoutName)) {
      await box.put(workout.workoutName, workout);
    }
  }

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
    return box.listenable(keys: [workoutName]).map((_) => box.get(workoutName));
  }

  ValueListenable<List<Workout>> getAllWorkoutsListenable() {
    return box.listenable().map((_) => box.values.toList());
  }

  // ✅ New: Favourite handling
  ValueListenable<List<Workout>> getFavouriteWorkoutsListenable() {
    return box.listenable().map(
          (_) => box.values.where((workout) => workout.isFavourite).toList(),
        );
  }

  Future<void> addFavourite(String workoutName) async {
    final workout = box.get(workoutName);
    if (workout != null) {
      final updated = workout.copyWith(isFavourite: true);
      await box.put(workoutName, updated);
    }
  }

  Future<void> removeFavourite(String workoutName) async {
    final workout = box.get(workoutName);
    if (workout != null && workout.isFavourite) {
      final updated = workout.copyWith(isFavourite: false);
      await box.put(workoutName, updated);
    }
  }

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

// Extension for mapping ValueListenables
extension MapListenable<T> on ValueListenable {
  ValueListenable<R> map<R>(R Function(T) convert) {
    final notifier = ValueNotifier<R>(convert(value));
    addListener(() {
      notifier.value = convert(value);
    });
    return notifier;
  }
}
