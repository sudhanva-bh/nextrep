import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/core/services/shared_preferences/shared_preferences.dart';
import 'package:nextrep/features/welcome/presentation/pages/welcome_page.dart';
import 'bottom_navigator_controller.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: AuthPrefs.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Show WelcomePage if not logged in
        if (!(snapshot.data ?? false)) {
          return const WelcomePage();
        }

        // If logged in, go to main app
        return BottomNavigatorController();
      },
    );
  }
}
