import 'package:hive/hive.dart';
import 'package:nextrep/core/entities/user/user_profile_model.dart';

class UserProfileService {
  static const _boxName = 'user_profile';
  final box = Hive.box<UserProfile>(_boxName);

  /// Create and save a new profile with default or given values
  Future<void> createInitialProfile({
    required String name,
    double height = 0.0,
    double weight = 0.0,
    String experience = '',
    String gender = '',
    double? targetWeight,
  }) async {
    final newUser = UserProfile(
      name: name,
      height: height,
      weight: weight,
      experience: experience,
      gender: gender,
      targetWeight: targetWeight,
    );

    await box.put('current_user', newUser);
  }

  /// Save a complete profile to local storage
  Future<void> saveToLocal(UserProfile profile) async {
    await box.put('current_user', profile);
  }

  /// Get the saved profile (if any)
  UserProfile? getFromLocal() {
    return box.get('current_user');
  }

  /// Delete the saved profile
  Future<void> deleteLocalProfile() async {
    await box.delete('current_user');
  }

  /*---------------------------------------------------------------------------*/

  /// Update just the name field
  Future<void> updateName(String newName) async {
    final currentUser = box.get('current_user');
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(name: newName);
      await box.put('current_user', updatedUser);
    }
  }

  /// Update just the height field
  Future<void> updateHeight(double newHeight) async {
    final currentUser = box.get('current_user');
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(height: newHeight);
      await box.put('current_user', updatedUser);
    }
  }

  /// Update just the weight field
  Future<void> updateWeight(double newWeight) async {
    final currentUser = box.get('current_user');
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(weight: newWeight);
      await box.put('current_user', updatedUser);
    }
  }

  /// Update just the targetWeight field
  Future<void> updateTargetWeight(double newtargetWeight) async {
    final currentUser = box.get('current_user');
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(targetWeight: newtargetWeight);
      await box.put('current_user', updatedUser);
    }
  }

  /// Update just the experience field
  Future<void> updateExperience(String newEperience) async {
    final currentUser = box.get('current_user');
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(experience: newEperience);
      await box.put('current_user', updatedUser);
    }
  }

  Future<void> updateGender(String newGender) async {
    final currentUser = box.get('current_user');
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(gender: newGender);
      await box.put('current_user', updatedUser);
    }
  }
}
