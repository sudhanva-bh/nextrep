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
          print("🔍 Calling syncOnRegister...");

          final syncResult = await authController.syncOnRegister(
            user.uid,
            name,
          );
          print("📌 syncOnRegister completed");

          setState(() {
            isLoading = false;
          });

          syncResult.fold(
            (failure) {
              print("❌ syncOnRegister failed: ${failure.message}");
              showSnackBar(context, failure.message);
            },
            (_) {
              print(
                "✅ syncOnRegister success -> Navigating to GenderCollection",
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
          print("🔍 Calling syncOnLogin...");

          final syncResult = await authController.syncOnLogin(user.uid);
          print("📌 syncOnLogin completed");

          setState(() {
            isLoading = false;
          });

          syncResult.fold(
            (failure) {
              print("❌ syncOnLogin failed: ${failure.message}");
              showSnackBar(context, failure.message);
            },
            (_) {
              print("✅ syncOnLogin success -> Navigating to HomePage");
              NavigateWithFadeNoBack(context, BottomNavigatorController());
            },
          );
        },
      );
    }
  }

  void continueWithGoogle() {
    showSnackBar(context, "Coming Soon!");
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
                              child: Column(
                                children: [
                                  currentSection,
                                  IconButton(
                                    onPressed: () async {
                                      final authResult = await ref
                                          .read(authControllerProvider)
                                          .emailSignIn(
                                            "bhsudhanva@gmail.com",
                                            "Test123",
                                          );
                                      authResult.fold(
                                        (_) {},
                                        (user) async {
                                          await ref
                                              .read(authControllerProvider)
                                              .syncOnLogin(user.uid);
                                          NavigateWithFadeNoBack(
                                            context,
                                            BottomNavigatorController(),
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.lock),
                                  ),
                                ],
                              ),
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
