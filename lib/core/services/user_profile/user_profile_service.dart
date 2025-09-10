import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nextrep/core/entities/user/user_profile_model.dart';

class UserProfileService {
  static const _boxName = 'user_profile';
  final box = Hive.box<UserProfile>(_boxName);

  /* --------------------- Profile Management --------------------- */

  /// Create and save a new profile
  Future<void> createInitialProfile({
    required String name,
    double height = 0.0,
    String experience = '',
    String gender = '',
    double? targetWeight,
  }) async {
    final newUser = UserProfile(
      name: name,
      height: height,
      weightHistory: [], // start empty
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

  /// Get the saved profile
  UserProfile? getFromLocal() => box.get('current_user');

  /// Delete the saved profile
  Future<void> deleteLocalProfile() async => box.delete('current_user');

  /* --------------------- Profile Updates --------------------- */

  /// Generic update function for immutability
  Future<void> updateProfile(UserProfile Function(UserProfile) updater) async {
    final box = await Hive.openBox<UserProfile>('user_profile');
    final current = box.get('current_user');
    if (current != null) {
      final updatedUser = updater(current);
      // ✅ This replaces the entire object, forcing ValueListenableBuilder to rebuild
      await box.put('current_user', updatedUser);
    }
  }

  /// Update name
  Future<void> updateName(String newName) async =>
      updateProfile((p) => p.copyWith(name: newName));

  /// Update height
  Future<void> updateHeight(double newHeight) async =>
      updateProfile((p) => p.copyWith(height: newHeight));

  /// Update target weight
  Future<void> updateTargetWeight(double newTargetWeight) async =>
      updateProfile((p) => p.copyWith(targetWeight: newTargetWeight));

  /// Update experience
  Future<void> updateExperience(String newExperience) async =>
      updateProfile((p) => p.copyWith(experience: newExperience));

  /// Update gender
  Future<void> updateGender(String newGender) async =>
      updateProfile((p) => p.copyWith(gender: newGender));

  Future<void> updatenewUser(bool status) async =>
      updateProfile((p) => p.copyWith(isNewUser: status));

  /* --------------------- Weight History --------------------- */

  /// Add a new weight entry with timestamp.
  /// If there's an entry within the last hour, replace it instead of adding.
  Future<void> addWeightEntry(double weight, {DateTime? date}) async {
    final now = date ?? DateTime.now();

    await updateProfile((p) {
      final updatedHistory = List<WeightEntry>.from(p.weightHistory);

      if (updatedHistory.isNotEmpty) {
        final lastEntry = updatedHistory.last;
        final difference = now.difference(lastEntry.date).inMinutes;
        if (difference.abs() <= 60) {
          updatedHistory[updatedHistory.length - 1] = WeightEntry(
            date: now,
            weight: weight,
          );
        } else {
          updatedHistory.add(WeightEntry(date: now, weight: weight));
        }
      } else {
        updatedHistory.add(WeightEntry(date: now, weight: weight));
      }

      return p.copyWith(weightHistory: updatedHistory);
    });
  }

  /// Get the latest weight (if any)
  double? getLatestWeight() {
    final profile = getFromLocal();
    if (profile == null || profile.weightHistory.isEmpty) return null;
    return profile.weightHistory.last.weight;
  }

  /// Remove the last recorded weight
  Future<void> removeLastWeightEntry() async {
    await updateProfile(
      (p) => p.copyWith(
        weightHistory: p.weightHistory.isNotEmpty
            ? p.weightHistory.sublist(0, p.weightHistory.length - 1)
            : [],
      ),
    );
  }

  /// Clear all weight history
  Future<void> clearWeightHistory() async {
    await updateProfile((p) => p.copyWith(weightHistory: []));
  }

  /// Sort weightHistory by date ascending and save back to the profile.
  Future<void> sortWeightHistory() async {
    await updateProfile((p) {
      final sorted = List<WeightEntry>.from(p.weightHistory)
        ..sort((a, b) => a.date.compareTo(b.date));
      return p.copyWith(weightHistory: sorted);
    });
  }

  /* --------------------- Reactivity --------------------- */

  /// Get a ValueListenable that emits the current user profile
  ValueListenable<UserProfile?> getProfileListenable() {
    return box
        .listenable(keys: ['current_user'])
        .mapValue((box) => box.get('current_user'));
  }
}

/* --------------------- Helper Extension --------------------- */

extension BoxListenHelper<T> on ValueListenable<Box<T>> {
  ValueListenable<R> mapValue<R>(R Function(Box<T> box) transformer) {
    final notifier = ValueNotifier<R>(transformer(value));
    addListener(() {
      notifier.value = transformer(value);
    });
    return notifier;
  }
}
