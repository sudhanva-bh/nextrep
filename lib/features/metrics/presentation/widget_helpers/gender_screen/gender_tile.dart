import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nextrep/core/constants/file_paths.dart';
import 'package:nextrep/core/theme/app_palette.dart';

enum Gender {
  male,
  female,
  nonBinary,
}

class GenderTile extends StatelessWidget {
  const GenderTile({
    super.key,
    required this.enabled,
    required this.gender,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  final bool enabled;
  final Gender gender;

  LottieBuilder get genderIcon {
    switch (gender) {
      case Gender.male:
        return Lottie.asset(FilePaths.maleLottie, height: 70);
      case Gender.female:
        return Lottie.asset(FilePaths.femaleLottie, height: 70);
      case Gender.nonBinary:
        return Lottie.asset(FilePaths.nonBinaryLottie, height: 70);
    }
  }

  String get genderName {
    switch (gender) {
      case Gender.male:
        return "Male";
      case Gender.female:
        return "Female";
      case Gender.nonBinary:
        return "Non Binary";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        width: 170,
        // height: 190,
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: enabled ? AppPalette.selectedSurface : AppPalette.surface,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(
            color: enabled ? AppPalette.selectedBorder : AppPalette.outline,
            width: enabled ? 2.5 : 1,
          ),
        ),
        duration: Duration(milliseconds: 100),
        child: Column(
          children: [
            genderIcon,
            SizedBox(height: 5),
            Text(
              genderName,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
