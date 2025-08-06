import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/file_paths.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_with_push.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/auth/presentation/widgets/continue_button.dart';
import 'package:nextrep/features/home/presentation/pages/home_page.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/experience_screen/experience_tile.dart';
import 'package:nextrep/core/services/user_profile/user_profile_service.dart';

class ExperienceCollection extends StatefulWidget {
  const ExperienceCollection({super.key});

  @override
  State<ExperienceCollection> createState() => _ExperienceCollectionState();
}

class _ExperienceCollectionState extends State<ExperienceCollection> {
  Experience selectedExperience = Experience.beginner;

  String beginnerMessage =
      "No prior gym experience? Start here with basic movements and light workouts to build strength and confidence.";
  String intermediateMessage =
      "Some training under your belt? These sessions add structure and moderate intensity to accelerate your progress.";
  String expertMessage =
      "Extensive gym background? Push your limits with advanced routines built for power, endurance, and precision.";

  String get currentImage {
    switch (selectedExperience) {
      case Experience.beginner:
        return FilePaths.beginnerExperience;
      case Experience.intermediate:
        return FilePaths.intermediateExperience;
      case Experience.advanced:
        return FilePaths.advancedExperience;
    }
  }

  String get currentMessage {
    switch (selectedExperience) {
      case Experience.beginner:
        return beginnerMessage;
      case Experience.intermediate:
        return intermediateMessage;
      case Experience.advanced:
        return expertMessage;
    }
  }

  void changeExperience(Experience newExperience) {
    setState(() {
      if (selectedExperience == newExperience) {
      } else {
        selectedExperience = newExperience;
      }
    });
  }

  Future<void> continueToHomePage() async {
    final cloudService = UserProfileService();
    await cloudService.updateExperience(selectedExperience.name);
    NavigateWithPush(context, HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox(
            height: screenHeight * (2 / 3),
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Animated image
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Image.asset(
                    currentImage,
                    key: ValueKey(currentImage),
                    fit: BoxFit
                        .cover, // use BoxFit.fill if you want no cropping at all
                    height: screenHeight * (2 / 3),
                    width: double.infinity,
                  ),
                ),

                // Overlay gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppPalette.transparent,
                        AppPalette.transparent,
                        AppPalette.background,
                        AppPalette.background,
                      ],
                      stops: [0, 0.55, 0.95, 1],
                    ),
                  ),
                ),

                // Fading message
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      currentMessage,
                      key: ValueKey(currentMessage),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Foreground content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                ExperienceTile(
                  enabled: selectedExperience == Experience.beginner,
                  gender: Experience.beginner,
                  onPressed: () => changeExperience(Experience.beginner),
                ),
                SizedBox(height: 12),
                ExperienceTile(
                  enabled: selectedExperience == Experience.intermediate,
                  gender: Experience.intermediate,
                  onPressed: () => changeExperience(Experience.intermediate),
                ),
                SizedBox(height: 12),
                ExperienceTile(
                  enabled: selectedExperience == Experience.advanced,
                  gender: Experience.advanced,
                  onPressed: () => changeExperience(Experience.advanced),
                ),
                SizedBox(height: 24),
                ContinueButton(
                  text: "Continue",
                  onPressed: continueToHomePage,
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
