import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:nextrep/core/entities/challenges/challenge.dart';

class ChallengesHiveSync {
  static Future<void> challengeModelToHive() async {
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(ChallengeAdapter());
    }
    await Hive.openBox<Challenge>('challengesBox');
    debugPrint(
      '✅ Challenge Model registered and \'challengesBox\' opened in Hive',
    );
  }
}
