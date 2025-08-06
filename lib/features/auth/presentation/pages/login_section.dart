import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextrep/features/auth/presentation/widgets/continue_button.dart';
import 'package:nextrep/features/auth/presentation/widgets/continue_with_button.dart';
import 'package:nextrep/features/auth/presentation/widgets/divider_with_text.dart';
import 'package:nextrep/features/auth/presentation/widgets/input_field.dart';

class LoginSection extends StatelessWidget {
  const LoginSection({
    super.key,
    required this.loginWithEmailPassword,
    required this.continueWithGoogle,
    required this.continueWithApple,
    required this.controllers,
    required this.switchSections,
  });

  final VoidCallback? loginWithEmailPassword;
  final VoidCallback? continueWithGoogle;
  final VoidCallback? continueWithApple;
  final VoidCallback? switchSections;

  final Map<String, TextEditingController> controllers;

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Welcome Back",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        SizedBox(
          height: 26,
        ),
        InputField(
          controller: controllers['email']!,
          hintText: "Email",
          alignment: FieldAlignment.top,
          fieldType: FieldType.email,
          validator: emailValidator,
        ),
        InputField(
          controller: controllers['password']!,
          hintText: "Password",
          alignment: FieldAlignment.bottom,
          fieldType: FieldType.password,
        ),
        SizedBox(
          height: 16,
        ),
        ContinueButton(
          text: "Login",
          onPressed: loginWithEmailPassword,
        ),
        DividerWithText(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ContinueWithButton(
              icon: FontAwesomeIcons.google,
              onPressed: continueWithGoogle,
            ),
            ContinueWithButton(
              icon: FontAwesomeIcons.apple,
              onPressed: continueWithApple,
            ),
          ],
        ),
      ],
    );
  }
}
