import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/core/common/providers.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_with_inkwell.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/home/presentation/widgets/bmi/bmi_card.dart';
import 'package:nextrep/features/home/presentation/widgets/daily_challenges/daily_challenges.dart';
import 'package:nextrep/features/home/presentation/widgets/favourite_workouts/favourite_workouts.dart';
import 'package:nextrep/features/home/presentation/widgets/todays_workout/todays_workout.dart';
import 'package:nextrep/features/home/presentation/widgets/weekly_brief_progress/weekly_brief_progress.dart';
import 'package:nextrep/features/profile/presentation/pages/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userProfileService = ref.watch(userProfileServiceProvider);
    final workoutsService = ref.read(workoutsServiceProvider);

    final currentUserProfile = userProfileService.getFromLocal()!;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18, left: 18, right: 18),
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
                        child: NavigateWithInkwell(
                          destination: ProfilePage(),
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(10),
                            child: Icon(
                              Icons.person,
                              color: AppPalette.background,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  WeeklyBriefProgress(),
                  SizedBox(height: 14),
                  TodaysWorkout(
                    listenable: workoutsService.workoutListenable(
                      "Arms Workout",
                    ),
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
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 18, left: 18, right: 18),
                child: FavouriteWorkouts(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
