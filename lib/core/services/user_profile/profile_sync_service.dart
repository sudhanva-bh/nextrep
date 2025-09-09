import 'package:fpdart/fpdart.dart';
import 'package:nextrep/core/error/failure.dart';
import 'package:nextrep/core/services/challenges/challenges_service.dart';
import 'package:nextrep/core/services/challenges/firebase_challenge_service.dart';
import 'package:nextrep/core/services/exercises/firebase_exercise_service.dart';
import 'package:nextrep/core/services/exercises/workouts_service.dart';
import 'package:nextrep/core/services/user_profile/user_profile_service.dart';
import 'package:nextrep/core/services/user_profile/firebase_user_profile_service.dart';

/// Handles syncing between local Hive storage and Firebase Firestore
class ProfileSyncService {
  final userCloudService = FirebaseUserProfileService();
  final userLocalService = UserProfileService();

  final challengesCloudService = FirebaseChallengeService();
  final challengesLocalService = ChallengesService();

  final workoutsCloudService = FirebaseExerciseService();
  final workoutsLocalService = WorkoutsService();

  /// Called after login: fetch from cloud and store locally
  Future<Either<Failure, Unit>> syncProfileOnLogin(String uid) async {
    try {
      // --- Sync User Profile ---
      final userCloudProfile = await userCloudService.fetchProfile(uid);
      if (userCloudProfile == null) {
        return left(Failure('No profile found in cloud for UID: $uid'));
      }
      await userLocalService.saveToLocal(userCloudProfile);

      // --- Sync User Challenges ---
      final cloudChallenges = await challengesCloudService
          .fetchProfileChallenges(uid);
      if (cloudChallenges == null) {
        return left(Failure('No challenges found in cloud for UID: $uid'));
      }
      await challengesLocalService.updateAllChallenges(cloudChallenges);

      // --- Sync User Workouts ---
      final cloudWorkouts = await workoutsCloudService.fetchProfileWorkouts(
        uid,
      );
      if (cloudWorkouts == null) {
        return left(Failure('No workouts found in cloud for UID: $uid'));
      }
      await workoutsLocalService.updateAllWorkouts(cloudWorkouts);

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Called after register: create a new cloud profile + presets
  Future<Either<Failure, Unit>> syncProfileOnRegister(
    String uid,
    String name,
  ) async {
    try {
      // --- Create and Sync User Profile ---
      await userLocalService.createInitialProfile(name: name);
      final localProfile = userLocalService.getFromLocal();
      if (localProfile == null) {
        return left(Failure('Failed to create local profile for UID: $uid'));
      }
      await userCloudService.uploadProfile(uid, localProfile);

      // --- Create Preset Challenges ---
      await challengesLocalService.putPresetChallenges();

      // --- Create Preset Workouts ---
      await workoutsLocalService.putPresetWorkouts();
      await workoutsLocalService.putPresetFavouriteWorkouts();

      // --- Sync Workouts ---
      await syncProfileOnCommand(uid);

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Called before logout: push local to cloud and clear local storage
  Future<Either<Failure, Unit>> syncProfileOnLogout(String uid) async {
    try {
      // --- Sync & Clear User Profile ---
      final localProfile = userLocalService.getFromLocal();
      if (localProfile == null) {
        return left(Failure('No profile found in local for UID: $uid'));
      }
      await userCloudService.uploadProfile(uid, localProfile);
      await userLocalService.deleteLocalProfile();

      // --- Sync & Clear Challenges ---
      final allSavedChallenges = challengesLocalService.getAllChallenges();
      await challengesCloudService.uploadProfileChallenges(
        uid,
        allSavedChallenges,
      );
      await challengesLocalService.deleteAllChallenges();

      // --- Sync & Clear Workouts ---
      final allSavedWorkouts = workoutsLocalService.getAllWorkouts();
      await workoutsCloudService.uploadProfileWorkouts(
        uid,
        allSavedWorkouts,
      );
      await workoutsLocalService.deleteAllWorkouts();

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Called anytime to push local data to cloud manually
  Future<Either<Failure, Unit>> syncProfileOnCommand(String uid) async {
    try {
      // --- Sync User Profile ---
      final localProfile = userLocalService.getFromLocal();
      if (localProfile == null) {
        return left(Failure('No profile found in local for UID: $uid'));
      }
      await userCloudService.updateProfileFields(uid, localProfile.toMap());

      // --- Sync Challenges ---
      final allSavedChallenges = challengesLocalService.getAllChallenges();
      await challengesCloudService.uploadProfileChallenges(
        uid,
        allSavedChallenges,
      );

      // --- Sync Workouts ---
      final allSavedWorkouts = workoutsLocalService.getAllWorkouts();
      await workoutsCloudService.uploadProfileWorkouts(
        uid,
        allSavedWorkouts,
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
