import 'package:hive_flutter/adapters.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';

class ExerciseService {
  static final box = Hive.box<Exercise>('exercisesBox');

  Exercise? getExerciseById(String id) {
    return box.get(id);
  }

  List<Exercise> getAllExercises() {
    return box.values.toList();
  }

  List<Exercise> searchExercisesByName(String query) {
    return box.values
        .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Exercise> getExercisesByCategory(String category) {
    return box.values
        .where((e) => e.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  List<Exercise> getExercisesByBodyPart(String bodyPart) {
    return box.values
        .where((e) => e.bodyPart.toLowerCase() == bodyPart.toLowerCase())
        .toList();
  }

  List<Exercise> getExercisesByTargetMuscle(String targetMuscle) {
    return box.values
        .where(
          (e) => e.targetMuscle.toLowerCase() == targetMuscle.toLowerCase(),
        )
        .toList();
  }

  List<Exercise> getExercisesByDifficulty(String difficulty) {
    return box.values
        .where((e) => e.difficulty.toLowerCase() == difficulty.toLowerCase())
        .toList();
  }

  List<Exercise> getExercisesByEquipment(String equipment) {
    return box.values
        .where((e) => e.equipment.toLowerCase() == equipment.toLowerCase())
        .toList();
  }

  List<Exercise> filterExercises({
    String? bodyPart,
    String? difficulty,
    String? equipment,
    String? category,
  }) {
    return box.values.where((e) {
      final matchesBodyPart =
          bodyPart == null ||
          e.bodyPart.toLowerCase() == bodyPart.toLowerCase();
      final matchesDifficulty =
          difficulty == null ||
          e.difficulty.toLowerCase() == difficulty.toLowerCase();
      final matchesEquipment =
          equipment == null ||
          e.equipment.toLowerCase() == equipment.toLowerCase();
      final matchesCategory =
          category == null ||
          e.category.toLowerCase() == category.toLowerCase();

      return matchesBodyPart &&
          matchesDifficulty &&
          matchesEquipment &&
          matchesCategory;
    }).toList();
  }
}
