import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nextrep/core/common/utils/show_snackbar.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/entities/workout/workout.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_run_function.dart';
import 'package:nextrep/core/services/exercises/exercise_raw_data_service.dart';
import 'package:nextrep/core/services/exercises/workouts_service.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/edit_workout/presentation/pages/edit_exercise.dart/edit_workout.dart';
import 'package:nextrep/features/preview_workout/presentation/utils/bottom_workout_preview_popup.dart';
import 'package:nextrep/features/preview_workout/presentation/widgets/exercise_session_card.dart';
import 'package:nextrep/features/preview_workout/presentation/widgets/overview.dart';
import 'package:nextrep/features/start_workout/presentation/pages/start_workout.dart';

class PreviewWorkout extends StatefulWidget {
  final ValueListenable<Workout?> workoutListenable;

  const PreviewWorkout({super.key, required this.workoutListenable});

  @override
  State<PreviewWorkout> createState() => _PreviewWorkoutState();
}

class _PreviewWorkoutState extends State<PreviewWorkout> {
  final workoutsService = ExerciseService();

  List<Exercise> _getExercises(Workout workout) {
    return workout.exercises
        .map((s) => workoutsService.getExerciseById(s.workoutId))
        .toList();
  }

  String _getWorkoutsNames(List<Exercise> exercises) {
    return exercises.map((e) => e.name).join(', ');
  }

  List<String> _getPrimaryMuscleGroups(List<Exercise> exercises) {
    return exercises
        .map(
          (e) => e.targetMuscle[0].toUpperCase() + e.targetMuscle.substring(1),
        )
        .toSet()
        .toList();
  }

  List<String> _getSecondaryMuscleGroups(List<Exercise> exercises) {
    return exercises
        .expand(
          (e) => e.secondaryMuscles,
        ) // flatten List<List<String>> → List<String>
        .map((m) => m[0].toUpperCase() + m.substring(1)) // capitalize
        .toSet() // unique
        .toList();
  }

  String _getVolume(Workout workout) {
    final volume = workout.exercises
        .expand((exercise) => exercise.sets)
        .fold<double>(0, (sum, set) => sum + (set.reps * set.weight));

    return volume.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Workout?>(
      valueListenable: widget.workoutListenable,
      builder: (context, workout, _) {
        if (workout == null) {
          return const Center(child: Text("No workout found"));
        }

        final exercises = _getExercises(workout);

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StartWorkout(
                    workout: workout,
                    startTime: DateTime.now(),
                  ),
                ),
              );
            },
            backgroundColor: AppPalette.secondary,
            label: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Start",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                actions: [
                  // Favourite button
                  IconButton(
                    onPressed: () async {
                      await WorkoutsService().addFavourite(workout.workoutName);
                      showSnackBar(context, 'Workout added to favourites!');
                    },
                    icon: Icon(
                      workout.isFavourite ? Icons.star : Icons.star_border,
                      color: workout.isFavourite
                          ? AppPalette.primary
                          : AppPalette.onSurface,
                    ),
                  ),

                  // Edit Workout button
                  IconButton(
                    onPressed: () {
                      Navigator.push<Workout>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditWorkout(
                            workout: workout,
                            exercises: exercises,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    color: AppPalette.onSurface,
                  ),
                ],
                pinned: true,
                collapsedHeight: 70,
                expandedHeight: 400,
                backgroundColor: AppPalette.surface,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      workout.workoutName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(workout.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppPalette.background.withAlpha(155),
                              AppPalette.background,
                            ],
                            stops: const [0, 0.6, 1],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Overview(
                        length: workout.exercises.length,
                        volume: _getVolume(workout),
                        workoutsNames: _getWorkoutsNames(exercises),
                        primaryMuscleGroups: _getPrimaryMuscleGroups(exercises),
                        secondaryMuscleGroups: _getSecondaryMuscleGroups(
                          exercises,
                        ),
                      ),
                      const SizedBox(height: 20),
                      for (int i = 0; i < workout.exercises.length; i++) ...[
                        NavigateRunFunction(
                          onTap: () {
                            BottomWorkoutPreviewPopup.showPopup(
                              context,
                              exercises[i],
                            );
                          },
                          child: ExerciseSessionCard(
                            exercise: exercises[i],
                            exerciseSession: workout.exercises[i],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
