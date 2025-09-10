import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/core/services/challenges/challenges_service.dart';
import 'package:nextrep/core/services/exercises/exercise_raw_data_service.dart';
import 'package:nextrep/core/services/exercises/workouts_service.dart';
import 'package:nextrep/core/services/user_profile/user_profile_service.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

/// Provides the FirebaseAuth instance (so it can be injected elsewhere)
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

/// Provides a stream of auth state (null = logged out, User = logged in)
final authStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});

final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService();
});

final challengesServiceProvider = Provider<ChallengesService>((ref) {
  return ChallengesService();
});

final exerciseServiceProvider = Provider<ExerciseService>((ref) {
  return ExerciseService();
});

final workoutsServiceProvider = Provider<WorkoutsService>((ref) {
  return WorkoutsService();
});

