import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/file_paths.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';
import 'package:nextrep/core/entities/workout/workout.dart';
import 'package:nextrep/core/services/exercises/exercise_raw_data_service.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/preview_workout/presentation/widgets/exercise_session_card.dart';
import 'package:nextrep/features/preview_workout/presentation/widgets/overview.dart';

class PreviewWorkout extends StatefulWidget {
  const PreviewWorkout({super.key, required this.workout});

  final Workout workout;

  @override
  State<PreviewWorkout> createState() => _PreviewWorkoutState();
}

class _PreviewWorkoutState extends State<PreviewWorkout> {
  List<Exercise> exercises = [];
  final workoutsService = ExerciseService();

  @override
  void initState() {
    for (ExerciseSession exerciseSession in widget.workout.exercises) {
      exercises.add(
        workoutsService.getExerciseById(exerciseSession.workoutId),
      );
    }
    super.initState();
  }

  String getWorkoutsNames() {
    return exercises.map((e) => e.name).join(', ');
  }

  String getMuscleGroups() {
    return exercises
        .map(
          (e) => e.targetMuscle[0].toUpperCase() + e.targetMuscle.substring(1),
        )
        .toSet()
        .join(', ');
  }

  String getVolume() {
    final volume = widget.workout.exercises
        .expand((exercise) => exercise.sets)
        .fold<double>(0, (sum, set) => sum + (set.reps * set.weight));

    return volume.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppPalette.secondary,
        label: Row(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // Sliver AppBar
          SliverAppBar(
            pinned: true,
            collapsedHeight: 70,
            expandedHeight: 400,
            // leading: Icon(Icons.arrow_back),
            backgroundColor: AppPalette.surface,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                widget.workout.workoutName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(WorkoutImagePaths.arms),
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
                        stops: [0, 0.6, 1],
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
                    length: widget.workout.exercises.length,
                    volume: getVolume(),
                    workoutsNames: getWorkoutsNames(),
                    muscleGroups: getMuscleGroups(),
                  ),
                  SizedBox(height: 20),
                  for (int i = 0; i < widget.workout.exercises.length; i++) ...[
                    ExerciseSessionCard(
                      exercise: exercises[i],
                      exerciseSession: widget.workout.exercises[i],
                    ),
                    SizedBox(height: 12),
                  ],
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
