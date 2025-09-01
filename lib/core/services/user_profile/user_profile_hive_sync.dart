import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:nextrep/core/entities/user/user_profile_model.dart';

class UserProfileHiveSync {
  static Future<void> userModelToHive() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserProfileAdapter());
    }

    await Hive.openBox<UserProfile>('user_profile');
    debugPrint(
      '✅ User Model registered and \'user_profile box\' opened in Hive',
    );
  }
}
