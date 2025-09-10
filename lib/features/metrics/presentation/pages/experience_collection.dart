import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/bottom_navigator_controller.dart';
import 'package:nextrep/core/common/providers.dart';
import 'package:nextrep/core/constants/file_paths.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_with_push.dart';
import 'package:nextrep/core/services/user_profile/profile_sync_service.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/auth/presentation/widgets/continue_button.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/experience_screen/experience_tile.dart';

class ExperienceCollection extends ConsumerStatefulWidget {
  const ExperienceCollection({super.key});

  @override
  ConsumerState<ExperienceCollection> createState() =>
      _ExperienceCollectionState();
}

class _ExperienceCollectionState extends ConsumerState<ExperienceCollection> {
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
      selectedExperience = newExperience;
    });
  }

  Future<void> continueToHomePage() async {
    final userProfileService = ref.read(userProfileServiceProvider);
    await userProfileService.updatenewUser(false);
    await userProfileService.updateExperience(selectedExperience.name);

    await ProfileSyncService().syncProfileOnCommand(
      FirebaseAuth.instance.currentUser!.uid,
    );

    NavigateWithPush(context, const BottomNavigatorController());
  }

  void skipToHome(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Warning"),
        content: const Text(
          "Are you sure you want to skip? You may face errors if data has not been entered correctly.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              NavigateWithPush(context, const BottomNavigatorController());
            },
            child: const Text("Yes, Skip"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => skipToHome(context),
        label: const Text("Skip"),
        icon: const Icon(Icons.arrow_forward),
      ),
      body: Stack(
        children: [
          // Background image
          SizedBox(
            height: screenHeight * (2 / 3),
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Image.asset(
                    currentImage,
                    key: ValueKey(currentImage),
                    fit: BoxFit.cover,
                  ),
                ),
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
                const Spacer(),
                ExperienceTile(
                  enabled: selectedExperience == Experience.beginner,
                  gender: Experience.beginner,
                  onPressed: () => changeExperience(Experience.beginner),
                ),
                const SizedBox(height: 12),
                ExperienceTile(
                  enabled: selectedExperience == Experience.intermediate,
                  gender: Experience.intermediate,
                  onPressed: () => changeExperience(Experience.intermediate),
                ),
                const SizedBox(height: 12),
                ExperienceTile(
                  enabled: selectedExperience == Experience.advanced,
                  gender: Experience.advanced,
                  onPressed: () => changeExperience(Experience.advanced),
                ),
                const SizedBox(height: 24),
                ContinueButton(
                  text: "Continue",
                  onPressed: continueToHomePage,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
