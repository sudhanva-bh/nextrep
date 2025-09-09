import 'dart:typed_data';

import 'package:hive_flutter/adapters.dart';
import 'package:nextrep/core/services/challenges/challenges_hive_sync.dart';
import 'package:nextrep/core/services/exercises/exercise_raw_data_hive_sync.dart';
import 'package:nextrep/core/services/exercises/workout_hive_sync.dart';
import 'package:nextrep/core/services/user_profile/user_profile_hive_sync.dart';

class HiveInitService {
  static Future<void> initHive() async {
    await Hive.initFlutter();

    await UserProfileHiveSync.userModelToHive();
    await ChallengesHiveSync.challengeModelToHive();
    await ExerciseHiveSync.cacheExercisesToHive();
    await ExerciseModelHiveSync.exerciseModelsToHive();
    await Hive.openBox<Uint8List>('muscle_images');
  }
}
