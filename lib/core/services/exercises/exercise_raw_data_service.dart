import 'package:hive_flutter/adapters.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';

class ExerciseService {
  static final box = Hive.box<Exercise>('exercisesBox');

  /* --------------------- Get Exercises --------------------- */

  /// Get a single exercise by its unique ID
  Exercise getExerciseById(String id) {
    return box.get(id)!;
  }

  /// Get all saved exercises
  List<Exercise> getAllExercises() {
    return box.values.toList();
  }

  /* --------------------- Search & Filter --------------------- */

  /// Search and filter exercises from the Hive box.
  ///
  /// - Performs a case-insensitive name search
  /// - Supports multiple filters (body part, difficulty, equipment, etc.)
  /// - Can include secondary muscles in the search
  List<Exercise> searchAndFilterExercises({
    String? query,
    String? bodyPart,
    String? difficulty,
    String? equipment,
    String? category,
    String? targetMuscle,
    bool includeSecondaryMuscles = false,
  }) {
    final lowercasedQuery = query?.toLowerCase();
    final lowercasedTargetMuscle = targetMuscle?.toLowerCase();

    return box.values.where((exercise) {
      final matchesQuery =
          lowercasedQuery == null ||
          exercise.name.toLowerCase().contains(lowercasedQuery);

      final matchesBodyPart =
          bodyPart == null ||
          exercise.bodyPart.toLowerCase() == bodyPart.toLowerCase();

      final matchesDifficulty =
          difficulty == null ||
          exercise.difficulty.toLowerCase() == difficulty.toLowerCase();

      final matchesEquipment =
          equipment == null ||
          exercise.equipment.toLowerCase() == equipment.toLowerCase();

      final matchesCategory =
          category == null ||
          exercise.category.toLowerCase() == category.toLowerCase();

      final matchesTargetMuscles =
          lowercasedTargetMuscle == null ||
          exercise.targetMuscle.toLowerCase() == lowercasedTargetMuscle ||
          (includeSecondaryMuscles &&
              exercise.secondaryMuscles.any(
                (muscle) => muscle.toLowerCase() == lowercasedTargetMuscle,
              ));

      return matchesQuery &&
          matchesBodyPart &&
          matchesDifficulty &&
          matchesEquipment &&
          matchesCategory &&
          matchesTargetMuscles;
    }).toList();
  }

  /* --------------------- Static Metadata --------------------- */

  /// Returns a static, sorted list of all exercise categories
  List<String> getAllCategories() {
    return [
      'balance',
      'cardio',
      'mobility',
      'plyometrics',
      'rehabilitation',
      'strength',
      'stretching',
    ];
  }

  /// Returns a static, sorted list of all body parts
  List<String> getAllBodyParts() {
    return [
      'back',
      'cardio',
      'chest',
      'lower arms',
      'lower legs',
      'neck',
      'shoulders',
      'upper arms',
      'upper legs',
      'waist',
    ];
  }

  /// Returns a static, sorted list of all primary target muscles
  List<String> getAllTargetMuscles() {
    return [
      // Neck/Upper back stabilizers
      'levator scapulae',
      'traps',
      'spine',
      'upper back',

      // Chest & shoulders
      'pectorals',
      'serratus anterior',
      'delts',
      'lats',

      // Arms
      'biceps',
      'triceps',
      'forearms',

      // Core
      'abs',

      // Hips & glutes
      'adductors',
      'abductors',
      'glutes',

      // Legs
      'quads',
      'hamstrings',
      'calves',

      // Misc
      'cardio',
    ];
  }

  /// Returns a static, sorted list of all secondary muscles
  List<String> getAllSecondaryMuscles() {
    return [
      'abdominals',
      'ankle stabilizers',
      'ankles',
      'back',
      'biceps',
      'brachialis',
      'calves',
      'chest',
      'core',
      'deltoids',
      'feet',
      'forearms',
      'glutes',
      'grip muscles',
      'groin',
      'hamstrings',
      'hands',
      'hip flexors',
      'inner thighs',
      'latissimus dorsi',
      'lats',
      'lower abs',
      'lower back',
      'obliques',
      'quadriceps',
      'rear deltoids',
      'rhomboids',
      'rotator cuff',
      'shins',
      'shoulders',
      'soleus',
      'sternocleidomastoid',
      'trapezius',
      'traps',
      'triceps',
      'upper back',
      'upper chest',
      'wrist extensors',
      'wrist flexors',
      'wrists',
    ];
  }

  /// Returns a static, sorted list of all equipment types
  List<String> getAllEquipment() {
    return [
      'assisted',
      'band',
      'barbell',
      'body weight',
      'bosu ball',
      'cable',
      'dumbbell',
      'elliptical machine',
      'exercise ball',
      'ez barbell',
      'hammer',
      'kettlebell',
      'leverage machine',
      'medicine ball',
      'olympic barbell',
      'resistance band',
      'roller',
      'rope',
      'skierg machine',
      'sled machine',
      'smith machine',
      'stability ball',
      'stationary bike',
      'stepmill machine',
      'tire',
      'trap bar',
      'weighted',
      'wheel roller',
    ];
  }
}
