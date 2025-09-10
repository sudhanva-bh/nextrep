import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/core/common/providers.dart';
import 'package:nextrep/core/entities/workout/workout.dart';
import 'package:nextrep/core/services/exercises/workouts_service.dart';
import 'package:nextrep/features/all_workouts/presentation/widgets/add_workouts_dialogue.dart';
import 'package:nextrep/features/edit_workout/presentation/pages/edit_exercise.dart/edit_workout.dart';
import 'package:nextrep/features/home/presentation/widgets/favourite_workouts/favourite_workouts_tiles.dart';

class AllWorkouts extends ConsumerWidget {
  const AllWorkouts({super.key});

  void _showAddWorkoutDialog(
    BuildContext context,
    WorkoutsService workoutService,
  ) async {
    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (context) => const AddWorkoutDialog(),
    );

    if (result != null) {
      final workoutName = result['name'];
      final imagePath = result['imagePath'];

      if (workoutName != null && imagePath != null) {
        final newWorkout = Workout(
          workoutName: workoutName,
          imagePath: imagePath,
          exercises: [],
        );

        await workoutService.uploadNewWorkout(newWorkout);

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditWorkout(
                workout: newWorkout,
                exercises: const [],
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutService = ref.read(workoutsServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Workouts",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<Workout>>(
        valueListenable: workoutService.getAllWorkoutsListenable(),
        builder: (context, workouts, _) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (workouts.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 48.0),
                          child: Text('No workouts created yet.'),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: workouts.length,
                        itemBuilder: (context, index) {
                          return FavouriteWorkoutsTiles(
                            workout: workouts[index],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                      ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton.icon(
                        icon: const Icon(Icons.add),
                        onPressed: () =>
                            _showAddWorkoutDialog(context, workoutService),
                        label: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Add Workout",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
