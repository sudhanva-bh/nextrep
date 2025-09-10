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
  final _userCloudService = FirebaseUserProfileService();
  final _userLocalService = UserProfileService();

  final _challengesCloudService = FirebaseChallengeService();
  final _challengesLocalService = ChallengesService();

  final _workoutsCloudService = FirebaseExerciseService();
  final _workoutsLocalService = WorkoutsService();

  /// Called after login: fetch from cloud and store locally
  /// Called after any login or registration.
  /// Checks if a cloud profile exists. If so, it syncs data down to local storage.
  /// If not, it creates a new local profile with presets and syncs it up to the cloud.
  Future<Either<Failure, Unit>> syncOnUserAuthenticated(String uid, String name) async {
    try {
      // First, try to fetch the profile from the cloud.
      final userCloudProfile = await _userCloudService.fetchProfile(uid);

      if (userCloudProfile != null) {
        // --- PROFILE EXISTS: This is a returning user (LOGIN SCENARIO) ---
        print("Existing user found. Syncing from cloud to local.");

        // Sync profile, challenges, and workouts from cloud to local storage.
        await _userLocalService.saveToLocal(userCloudProfile);

        final cloudChallenges = await _challengesCloudService.fetchProfileChallenges(uid);
        // Use `?? []` to gracefully handle cases where a user might not have challenges yet.
        await _challengesLocalService.updateAllChallenges(cloudChallenges ?? []);

        final cloudWorkouts = await _workoutsCloudService.fetchProfileWorkouts(uid);
        await _workoutsLocalService.updateAllWorkouts(cloudWorkouts ?? []);
        
      } else {
        // --- PROFILE DOES NOT EXIST: This is a new user (REGISTER SCENARIO) ---
        print("New user detected. Creating profile and syncing to cloud.");

        // 1. Create the user profile locally.
        await _userLocalService.createInitialProfile(name: name);
        final localProfile = _userLocalService.getFromLocal();
        if (localProfile == null) {
          return left(Failure('Failed to create local profile for UID: $uid'));
        }

        // 2. Create preset challenges and workouts locally.
        await _challengesLocalService.putPresetChallenges();
        await _workoutsLocalService.putPresetWorkouts();
        await _workoutsLocalService.putPresetFavouriteWorkouts();
        
        // 3. Upload the new profile and all presets to the cloud.
        await _userCloudService.uploadProfile(uid, localProfile);

        final allChallenges = _challengesLocalService.getAllChallenges();
        await _challengesCloudService.uploadProfileChallenges(uid, allChallenges);
        
        final allWorkouts = _workoutsLocalService.getAllWorkouts();
        await _workoutsCloudService.uploadProfileWorkouts(uid, allWorkouts);
      }

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Called before logout: push local to cloud and clear local storage
  Future<Either<Failure, Unit>> syncProfileOnLogout(String uid) async {
    try {
      // --- Sync & Clear User Profile ---
      final localProfile = _userLocalService.getFromLocal();
      if (localProfile == null) {
        return left(Failure('No profile found in local for UID: $uid'));
      }
      await _userCloudService.uploadProfile(uid, localProfile);
      await _userLocalService.deleteLocalProfile();

      // --- Sync & Clear Challenges ---
      final allSavedChallenges = _challengesLocalService.getAllChallenges();
      await _challengesCloudService.uploadProfileChallenges(
        uid,
        allSavedChallenges,
      );
      await _challengesLocalService.deleteAllChallenges();

      // --- Sync & Clear Workouts ---
      final allSavedWorkouts = _workoutsLocalService.getAllWorkouts();
      await _workoutsCloudService.uploadProfileWorkouts(
        uid,
        allSavedWorkouts,
      );
      await _workoutsLocalService.deleteAllWorkouts();

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Called anytime to push local data to cloud manually
  Future<Either<Failure, Unit>> syncProfileOnCommand(String uid) async {
    try {
      // --- Sync User Profile ---
      final localProfile = _userLocalService.getFromLocal();
      if (localProfile == null) {
        return left(Failure('No profile found in local for UID: $uid'));
      }
      await _userCloudService.updateProfileFields(uid, localProfile.toMap());

      // --- Sync Challenges ---
      final allSavedChallenges = _challengesLocalService.getAllChallenges();
      await _challengesCloudService.uploadProfileChallenges(
        uid,
        allSavedChallenges,
      );

      // --- Sync Workouts ---
      final allSavedWorkouts = _workoutsLocalService.getAllWorkouts();
      await _workoutsCloudService.uploadProfileWorkouts(
        uid,
        allSavedWorkouts,
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
