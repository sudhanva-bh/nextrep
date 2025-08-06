import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nextrep/core/error/failure.dart';
import 'package:nextrep/features/auth/data/auth_service.dart';
import 'package:nextrep/core/services/user_profile/profile_sync_service.dart';

/// Provides an instance of AuthController (UI logic helper)
final authControllerProvider = Provider<AuthController>(
  (ref) => AuthController(),
);

/// Controller that bridges UI and AuthService
class AuthController {
  final _authService = AuthService();
  final _profileSyncService = ProfileSyncService();

  Future<Either<Failure, User>> emailSignIn(
    String email,
    String password,
  ) async {
    return await _authService.emailSignInService(email, password);
  }

  Future<Either<Failure, User>> emailRegister(
    String email,
    String password,
  ) async {
    return await _authService.emailRegisterService(email, password);
  }

  Future<Either<Failure, Unit>> logout() {
    return _authService.signOut();
  }

  Future<Either<Failure, Unit>> syncOnLogin(String uid) async {
    return await _profileSyncService.syncProfileOnLogin(uid);
  }
  
  Future<Either<Failure, Unit>> syncOnRegister(String uid, String name) async {
    return await _profileSyncService.syncProfileOnRegister(uid, name);
  }

  Future<Either<Failure, Unit>> syncOnLogout(String uid) async {
    return await _profileSyncService.syncProfileOnLogout(uid);
  }
}
