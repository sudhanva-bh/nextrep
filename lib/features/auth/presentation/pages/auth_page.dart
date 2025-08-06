import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/core/common/utils/loader.dart';
import 'package:nextrep/core/common/utils/show_snackbar.dart';
import 'package:nextrep/core/constants/file_paths.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_with_fade.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/auth/presentation/auth_controller.dart';
import 'package:nextrep/features/auth/presentation/pages/login_section.dart';
import 'package:nextrep/features/auth/presentation/pages/register_section.dart';
import 'package:nextrep/features/home/presentation/pages/home_page.dart';
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
      setState(() {
        isLoading = true;
      });

      final name = controllers["name"]!.text;
      final email = controllers["email"]!.text;
      final password = controllers["password"]!.text;

      final authController = ref.read(authControllerProvider);

      final authResult = await authController.emailRegister(email, password);

      authResult.fold(
        (failure) {
          isLoading = false;
          showSnackBar(context, failure.message);
        },
        (user) async {
          final syncResult = await authController.syncOnRegister(
            user.uid,
            name,
          );

          syncResult.fold(
            (failure) {
              isLoading = false;
              showSnackBar(context, failure.message);
            },
            (_) {
              isLoading = false;
              NavigateWithFadeNoBack(context, GenderCollection());
            },
          );
        },
      );
    }
  }

  Future<void> loginWithEmailPassword() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final email = controllers["email"]!.text;
      final password = controllers["password"]!.text;

      final authController = ref.read(authControllerProvider);

      final authResult = await authController.emailSignIn(email, password);

      authResult.fold(
        (failure) {
          isLoading = false;
          showSnackBar(context, failure.message);
        },
        (user) async {
          final syncResult = await authController.syncOnLogin(user.uid);

          syncResult.fold(
            (failure) {
              isLoading = false;
              showSnackBar(context, failure.message);
            },
            (_) {
              isLoading = false;
              NavigateWithFadeNoBack(context, HomePage());
            },
          );
        },
      );
    }
  }

  void continueWithGoogle() {}

  void continueWithApple() {}

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
