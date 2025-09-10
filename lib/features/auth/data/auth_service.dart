import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nextrep/core/error/failure.dart';
import 'package:nextrep/core/services/shared_preferences/shared_preferences.dart';

/// A simple service class to wrap FirebaseAuth logic.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static bool isInitialized = false;

  /// Sign in with email and password
  Future<Either<Failure, User>> emailSignInService(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await AuthPrefs.hasLoggedIn();
      return right(result.user!);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? "Login failed"));
    } catch (e) {
      return left(Failure("Unexpected error: ${e.toString()}"));
    }
  }

  /// Register a new user with email and password
  Future<Either<Failure, User>> emailRegisterService(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await AuthPrefs.hasLoggedIn();
      return right(result.user!);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? "Registration failed"));
    } catch (e) {
      return left(Failure("Unexpected error: ${e.toString()}"));
    }
  }

  static Future<void> initGoogleSignIn() async {
    if (!isInitialized) {
      await _googleSignIn.initialize(
        serverClientId:
            '808078870152-erd7ct05vmdqem342dv16cplm3rvhalg.apps.googleusercontent.com',
      );
    }
    isInitialized = true;
  }

  Future<Either<Failure, User>> googleSignInService() async {
    try {
      initGoogleSignIn();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final idToken = googleUser.authentication.idToken;
      final authorizationClient = googleUser.authorizationClient;
      GoogleSignInClientAuthorization? authorization = await authorizationClient
          .authorizationForScopes(['email', 'profile']);
      final accessToken = authorization?.accessToken;
      if (accessToken == null) {
        final authorization2 = await authorizationClient.authorizationForScopes(
          ['email', 'profile'],
        );
        if (authorization2?.accessToken == null) {
          throw FirebaseAuthException(code: "error", message: "error");
        }
        authorization = authorization2;
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );
      final UserCredential result = await _auth.signInWithCredential(
        credential,
      );
      await AuthPrefs.hasLoggedIn();
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
      await _googleSignIn.signOut();
      await _auth.signOut();
      await AuthPrefs.hasLoggedOut();
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Get the currently logged-in user (null if not logged in)
  User? get currentUser => _auth.currentUser;
}
