import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextrep/features/auth/presentation/widgets/continue_button.dart';
import 'package:nextrep/features/auth/presentation/widgets/continue_with_button.dart';
import 'package:nextrep/features/auth/presentation/widgets/divider_with_text.dart';
import 'package:nextrep/features/auth/presentation/widgets/input_field.dart';

class RegisterSection extends StatelessWidget {
  const RegisterSection({
    super.key,
    required this.registerWithEmailPassword,
    required this.continueWithGoogle,
    required this.continueWithApple,
    required this.controllers,
    required this.switchSections,
  });

  final VoidCallback? registerWithEmailPassword;
  final VoidCallback? continueWithGoogle;
  final VoidCallback? continueWithApple;
  final VoidCallback? switchSections;

  final Map<String, TextEditingController> controllers;

  String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Include at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Include at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Include at least one number';
    }
    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != controllers['password']!.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Begin your Journey",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        SizedBox(
          height: 26,
        ),
        InputField(
          controller: controllers['name']!,
          hintText: "Name",
          alignment: FieldAlignment.top,
          validator: nameValidator,
        ),
        InputField(
          controller: controllers['email']!,
          hintText: "Email",
          alignment: FieldAlignment.center,
          fieldType: FieldType.email,
          validator: emailValidator,
        ),
        InputField(
          controller: controllers['password']!,
          hintText: "Password",
          alignment: FieldAlignment.center,
          fieldType: FieldType.password,
          validator: passwordValidator,
        ),
        InputField(
          controller: controllers['confirmPassword']!,
          hintText: "Confirm Password",
          alignment: FieldAlignment.bottom,
          fieldType: FieldType.password,
          validator: confirmPasswordValidator,
        ),
        SizedBox(
          height: 16,
        ),
        ContinueButton(
          text: "Register",
          onPressed: registerWithEmailPassword,
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
