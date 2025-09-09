import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:nextrep/core/entities/user/user_profile_model.dart';

class UserProfileHiveSync {
  static Future<void> userModelToHive() async {
    // Register WeightEntryAdapter first
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(WeightEntryAdapter());
    }

    // Then register UserProfileAdapter
    if (true) {
      Hive.registerAdapter(UserProfileAdapter());
    }

    await Hive.openBox<UserProfile>('user_profile');
    debugPrint(
      '✅ UserProfile & WeightEntry models registered and \'user_profile\' box opened in Hive',
    );
  }
}
