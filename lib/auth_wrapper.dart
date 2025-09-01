import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nextrep/bottom_navigator_controller.dart';
import 'package:nextrep/core/common/utils/loader.dart';
import 'package:nextrep/features/welcome/presentation/pages/welcome_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader();
        }
        if (snapshot.hasData) {
          return BottomNavigatorController();
        } else {
          return WelcomePage();
        }
      },
    );
  }
}
