import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/bottom_navigator_controller.dart';
import 'package:nextrep/core/common/utils/loader.dart';
import 'package:nextrep/core/common/utils/show_snackbar.dart';
import 'package:nextrep/core/constants/file_paths.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_with_fade.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/auth/presentation/auth_controller.dart';
import 'package:nextrep/features/auth/presentation/pages/login_section.dart';
import 'package:nextrep/features/auth/presentation/pages/register_section.dart';
import 'package:nextrep/features/metrics/presentation/pages/gender_collection.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  late Widget currentSection;
  late Widget switchToNextSection;

  late bool isNewUser = true;

  late Map<String, TextEditingController> controllers;

  void goToLogin() {
    setState(() {
      currentSection = LoginSection(
        loginWithEmailPassword: loginWithEmailPassword,
        continueWithGoogle: continueWithGoogle,
        continueWithApple: continueWithApple,
        controllers: controllers,
        switchSections: goToRegister,
      );
      switchToNextSection = GestureDetector(
        onTap: goToRegister,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("New Here? "),
              Text(
                "Register",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      );
      isNewUser = false;
    });
  }

  void goToRegister() {
    setState(() {
      currentSection = RegisterSection(
        registerWithEmailPassword: registerWithEmailPassword,
        continueWithGoogle: continueWithGoogle,
        continueWithApple: continueWithApple,
        controllers: controllers,
        switchSections: goToLogin,
      );
      switchToNextSection = GestureDetector(
        onTap: goToLogin,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already a Member? "),
              Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      );
      isNewUser = true;
    });
  }

  Future<void> registerWithEmailPassword() async {
    if (formKey.currentState!.validate()) {
      print("✅ Form validated for Register");

      setState(() {
        isLoading = true;
      });

      final name = controllers["name"]!.text;
      final email = controllers["email"]!.text;
      final password = controllers["password"]!.text;
      print("📌 Register details => name: $name, email: $email");

      final authController = ref.read(authControllerProvider);
      print("🔍 Calling emailRegister...");

      final authResult = await authController.emailRegister(email, password);
      print("📌 emailRegister completed");

      authResult.fold(
        (failure) {
          print("❌ Register failed: ${failure.message}");
          setState(() {
            isLoading = false;
          });
          showSnackBar(context, failure.message);
        },
        (user) async {
          print("✅ Register success, uid: ${user.uid}");

          // MODIFIED: Call the single sync method
          print("🔍 Calling syncOnAuth for new user...");
          final syncResult = await authController.syncOnAuth(user.uid, name);
          print("📌 syncOnAuth completed");

          setState(() {
            isLoading = false;
          });

          syncResult.fold(
            (failure) {
              print("❌ syncOnAuth failed: ${failure.message}");
              showSnackBar(context, failure.message);
            },
            (_) {
              print(
                "✅ syncOnAuth success -> Navigating to GenderCollection",
              );
              NavigateWithFadeNoBack(context, GenderCollection());
            },
          );
        },
      );
    }
  }

  Future<void> loginWithEmailPassword() async {
    if (formKey.currentState!.validate()) {
      print("✅ Form validated for Login");

      setState(() {
        isLoading = true;
      });

      final email = controllers["email"]!.text;
      final password = controllers["password"]!.text;
      print("📌 Login details => email: $email");

      final authController = ref.read(authControllerProvider);
      print("🔍 Calling emailSignIn...");

      final authResult = await authController.emailSignIn(email, password);
      print("📌 emailSignIn completed");

      authResult.fold(
        (failure) {
          print("❌ Login failed: ${failure.message}");
          setState(() {
            isLoading = false;
          });
          showSnackBar(context, failure.message);
        },
        (user) async {
          print("✅ Login success, uid: ${user.uid}");

          // MODIFIED: Call the single sync method
          // For login, the name comes from the user object, with a fallback.
          print("🔍 Calling syncOnAuth for existing user...");
          final syncResult = await authController.syncOnAuth(
            user.uid,
            user.displayName ?? 'User',
          );
          print("📌 syncOnAuth completed");

          setState(() {
            isLoading = false;
          });

          syncResult.fold(
            (failure) {
              print("❌ syncOnAuth failed: ${failure.message}");
              showSnackBar(context, failure.message);
            },
            (_) {
              print("✅ syncOnAuth success -> Navigating to HomePage");
              NavigateWithFadeNoBack(context, BottomNavigatorController());
            },
          );
        },
      );
    }
  }

  void continueWithGoogle() async {
    // No form validation is needed for Google Sign-In.
    print("🚀 Initiating Google Sign-In flow");

    setState(() {
      isLoading = true;
    });

    final authController = ref.read(authControllerProvider);
    print("🔍 Calling controller.signInWithGoogle...");

    // 1. Attempt to sign in with Google
    final authResult = await authController.signInWithGoogle();
    print("📌 controller.signInWithGoogle completed");

    authResult.fold(
      (failure) {
        // --- HANDLE AUTHENTICATION FAILURE ---
        print("❌ Google Sign-In failed: ${failure.message}");
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, failure.message);
      },
      (user) async {
        // --- HANDLE AUTHENTICATION SUCCESS ---
        print("✅ Google Sign-In success, uid: ${user.uid}");
        print("🔍 Calling controller.syncOnAuth for Google user...");

        // 2. Call the unified sync method upon successful authentication
        final syncResult = await authController.syncOnAuth(
          user.uid,
          user.displayName ?? 'New User', // Get name from Google account
        );
        print("📌 controller.syncOnAuth completed");

        // Set loading to false now that all backend tasks are done
        setState(() {
          isLoading = false;
        });

        syncResult.fold(
          (failure) {
            // --- HANDLE SYNC FAILURE ---
            print("❌ syncOnAuth failed: ${failure.message}");
            showSnackBar(context, failure.message);
          },
          (_) {
            // --- HANDLE SYNC SUCCESS ---
            print("✅ syncOnAuth success -> Navigating to HomePage");
            // Navigate to the main app screen for both new and returning users
            NavigateWithFadeNoBack(context, BottomNavigatorController());
          },
        );
      },
    );
  }

  void continueWithApple() {
    showSnackBar(context, "Coming Soon!");
  }

  @override
  void initState() {
    super.initState();
    controllers = {
      'name': TextEditingController(),
      'email': TextEditingController(),
      'password': TextEditingController(),
      'confirmPassword': TextEditingController(),
    };
    goToRegister();
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loader()
        : Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              FilePaths.mainLogo,
                              height: 200,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 26,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: AppPalette.surface,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: currentSection,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          switchToNextSection,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
