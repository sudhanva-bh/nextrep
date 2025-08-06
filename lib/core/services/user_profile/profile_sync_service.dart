import 'package:fpdart/fpdart.dart';
import 'package:nextrep/core/error/failure.dart';
import 'package:nextrep/core/services/user_profile/user_profile_service.dart';
import 'package:nextrep/core/services/user_profile/firebase_user_profile_service.dart';

class ProfileSyncService {
  final cloudService = FirebaseUserProfileService();
  final localService = UserProfileService();

  /// Called after login: fetch from cloud and store locally
  Future<Either<Failure, Unit>> syncProfileOnLogin(String uid) async {
    try {
      final cloudProfile = await cloudService.fetchProfile(uid);

      if (cloudProfile == null) {
        return left(Failure('No profile found in cloud for UID: $uid'));
      }

      await localService.saveToLocal(cloudProfile);

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Called after register: create a new
  Future<Either<Failure, Unit>> syncProfileOnRegister(
    String uid,
    String name,
  ) async {
    try {
      await localService.createInitialProfile(name: name);
      final localProfile = localService.getFromLocal();

      if (localProfile == null) {
        return left(Failure('No profile found in local for UID: $uid'));
      }

      await cloudService.uploadProfile(uid, localProfile);
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Called before logout: push local to cloud and clear local storage
  Future<Either<Failure, Unit>> syncProfileOnLogout(String uid) async {
    try {
      final localProfile = localService.getFromLocal();

      if (localProfile == null) {
        return left(Failure('No profile found in local for UID: $uid'));
      }

      await cloudService.uploadProfile(uid, localProfile);
      await localService.deleteLocalProfile();

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Called anytime to push local data to cloud manually
  Future<Either<Failure, Unit>> syncProfileOnCommand(String uid) async {
    try {
      final localProfile = localService.getFromLocal();

      if (localProfile == null) {
        return left(Failure('No profile found in local for UID: $uid'));
      }

      await cloudService.updateProfileFields(uid, localProfile.toMap());

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
