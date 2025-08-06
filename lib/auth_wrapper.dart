import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nextrep/core/common/utils/loader.dart';
import 'package:nextrep/features/home/presentation/pages/home_page.dart';
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
          return HomePage();
        } else {
          return WelcomePage();
        }
      },
    );
  }
}
