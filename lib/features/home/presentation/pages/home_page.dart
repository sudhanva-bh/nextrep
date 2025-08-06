import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/core/common/utils/show_snackbar.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_with_fade.dart';
import 'package:nextrep/core/services/exercises/workouts_service.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/auth/presentation/auth_controller.dart';
import 'package:nextrep/features/home/presentation/widgets/bmi/bmi_card.dart';
import 'package:nextrep/features/home/presentation/widgets/daily_challenges/daily_challenges.dart';
import 'package:nextrep/features/home/presentation/widgets/todays_workout/todays_workout.dart';
import 'package:nextrep/features/home/presentation/widgets/weekly_brief_progress/weekly_brief_progress.dart';
import 'package:nextrep/core/services/user_profile/user_profile_service.dart';
import 'package:nextrep/features/welcome/presentation/pages/welcome_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final userProfileService = UserProfileService();

  Future<void> logOut() async {
    final authController = ref.read(authControllerProvider);
    await authController.syncOnLogout(FirebaseAuth.instance.currentUser!.uid);
    final result = await authController.logout();

    result.fold(
      (failure) => showSnackBar(context, failure.message),
      (_) => NavigateWithFadeNoBack(context, WelcomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserProfile = userProfileService.getFromLocal()!;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              currentUserProfile.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppPalette.onBackground,
                            boxShadow: WidgetProperties.dropShadow,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(10),
                            child: Icon(
                              Icons.person,
                              color: AppPalette.background,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: logOut,
                      child: WeeklyBriefProgress(),
                    ),
                    SizedBox(height: 14),
                    TodaysWorkout(
                      workout: WorkoutsService(
                        context: context,
                      ).getWorkout("Arms Workout")!,
                    ),
                    SizedBox(height: 14),
                    BmiCard(
                      userProfile: currentUserProfile,
                      userProfileService: userProfileService,
                    ),
                    SizedBox(height: 14),
                  ],
                ),
              ),
              DailyChallenges(),
            ],
          ),
        ),
      ),
    );
  }
}
