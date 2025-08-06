import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nextrep/core/error/failure.dart';

/// A simple service class to wrap FirebaseAuth logic.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in with email and password
  Future<Either<Failure, User>> emailSignInService(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(result.user!);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? "Login failed"));
    } catch (e) {
      return left(Failure("Unexpected error: ${e.toString()}"));
    }
  }

  /// Register a new user with email and password
  Future<Either<Failure, User>> emailRegisterService(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(result.user!);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? "Registration failed"));
    } catch (e) {
      return left(Failure("Unexpected error: ${e.toString()}"));
    }
  }

  /// Sign out the current user
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _auth.signOut();
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Get the currently logged-in user (null if not logged in)
  User? get currentUser => _auth.currentUser;
}
