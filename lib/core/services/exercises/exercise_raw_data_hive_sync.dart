import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';

class ExerciseHiveSync {
  static Future<void> cacheExercisesToHive() async {
    Hive.registerAdapter(ExerciseAdapter());
    final box = await Hive.openBox<Exercise>('exercisesBox');

    if (box.isEmpty) {
      final jsonStr = await rootBundle.loadString('assets/data/exercises.json');
      final List<dynamic> jsonList = json.decode(jsonStr);

      final exercises = jsonList.map((e) => Exercise.fromMap(e)).toList();

      for (var exercise in exercises) {
        await box.put(exercise.id, exercise);
      }
      debugPrint('✅ Exercises cached in Hive');
    } else {
      debugPrint('📦 Exercises already cached');
    }
  }
}
