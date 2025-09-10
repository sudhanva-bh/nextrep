import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/core/common/providers.dart';
import 'package:nextrep/core/common/utils/show_snackbar.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';
import 'package:nextrep/core/entities/workout/exercise_set.dart';
import 'package:nextrep/core/entities/workout/workout.dart';
import 'package:nextrep/core/services/exercises/exercise_raw_data_service.dart';
import 'package:nextrep/core/services/exercises/workouts_service.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/edit_workout/presentation/pages/add_exercise/add_exercise.dart';
import 'package:nextrep/features/edit_workout/presentation/pages/edit_exercise.dart/widgets/edit_tile.dart';

class EditWorkout extends ConsumerStatefulWidget {
  const EditWorkout({
    super.key,
    required this.workout,
    required this.exercises,
  });

  final Workout workout;
  final List<Exercise> exercises;

  @override
  ConsumerState<EditWorkout> createState() => _EditWorkoutState();
}

class _EditWorkoutState extends ConsumerState<EditWorkout> {
  late List<Exercise> _exercises; // local copy so we can reorder
  late Workout _workout;
  late WorkoutsService _workoutsService;
  late ExerciseService _exerciseService;

  @override
  void initState() {
    super.initState();
    _workoutsService = ref.read(workoutsServiceProvider);
    _exerciseService = ref.read(exerciseServiceProvider);
    _exercises = List.from(widget.exercises); // clone list
    _workout = widget.workout.copyWith();
  }

  void setStateWhenClosed() {
    setState(() {});
  }

  void addExercise(String workoutId) {
    final isDuplicate = _workout.exercises.any(
      (session) => session.workoutId == workoutId,
    );

    if (isDuplicate) {
      showSnackBar(context, 'This exercise is already in your workout.');
      return;
    }

    final exerciseToAdd = _exerciseService.getExerciseById(workoutId);

    setState(() {
      final newExerciseSession = ExerciseSession(
        workoutId: workoutId,
        sets: [ExerciseSet(reps: 12, weight: 10)],
      );

      final modifiedExerciseSessions = List<ExerciseSession>.from(
        _workout.exercises,
      );
      modifiedExerciseSessions.add(newExerciseSession);

      _exercises.add(exerciseToAdd);

      _workout = _workout.copyWith(exercises: modifiedExerciseSessions);
    });
  }

  void updateSet(
    int exerciseSessionIndex,
    int setIndex, {
    int? reps,
    double? weight,
  }) {
    // 1. Get a mutable copy of the exercise sessions
    final updatedSessions = List<ExerciseSession>.from(_workout.exercises);
    final sessionToUpdate = updatedSessions[exerciseSessionIndex];

    // 2. Get a mutable copy of the sets
    final updatedSets = List<ExerciseSet>.from(sessionToUpdate.sets);
    final setToUpdate = updatedSets[setIndex];

    // 3. Update the specific set
    updatedSets[setIndex] = setToUpdate.copyWith(
      reps: reps,
      weight: weight,
    );

    // 4. Update the specific session with the new sets list
    updatedSessions[exerciseSessionIndex] = sessionToUpdate.copyWith(
      sets: updatedSets,
    );

    // 5. Update the workout with the new sessions list
    _workout = _workout.copyWith(exercises: updatedSessions);
  }

  void deleteSet(int exerciseSessionIndex, int setIndex) {
    setState(() {
      // 1. Get a mutable copy of the exercise sessions
      final updatedSessions = List<ExerciseSession>.from(_workout.exercises);
      final sessionToUpdate = updatedSessions[exerciseSessionIndex];

      // 2. Get a mutable copy of the sets
      final updatedSets = List<ExerciseSet>.from(sessionToUpdate.sets);

      // 3. Remove the set at the specified index
      updatedSets.removeAt(setIndex);

      // 4. Update the session with the modified sets list
      updatedSessions[exerciseSessionIndex] = sessionToUpdate.copyWith(
        sets: updatedSets,
      );

      // 5. Update the workout state
      _workout = _workout.copyWith(exercises: updatedSessions);
    });
  }

  void addSet(int exerciseSessionIndex) {
    setState(() {
      // 1. Get a mutable copy of the exercise sessions
      final updatedSessions = List<ExerciseSession>.from(_workout.exercises);
      final sessionToUpdate = updatedSessions[exerciseSessionIndex];

      // 2. Get a mutable copy of the sets from the target session
      final updatedSets = List<ExerciseSet>.from(sessionToUpdate.sets);

      // 3. Create a new default set and add it to the end of the list
      final newSet = ExerciseSet(reps: 12, weight: 10.0);
      updatedSets.add(newSet);

      // 4. Update the specific session with the new, longer sets list
      updatedSessions[exerciseSessionIndex] = sessionToUpdate.copyWith(
        sets: updatedSets,
      );

      // 5. Update the workout state with the modified sessions list
      _workout = _workout.copyWith(exercises: updatedSessions);
    });
  }

  void deleteExercise(int index) {
    setState(() {
      final String exerciseName = _exercises[index].name;

      // 1. Remove the exercise from the local list of Exercise models
      _exercises.removeAt(index);

      // 2. Remove the exercise session from the workout's list
      final updatedSessions = List<ExerciseSession>.from(_workout.exercises);
      updatedSessions.removeAt(index);

      // 3. Update the workout state
      _workout = _workout.copyWith(exercises: updatedSessions);

      // 4. Show a confirmation snackbar
      showSnackBar(context, '$exerciseName removed.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "reset",
            tooltip: "Reset",
            onPressed: () {
              setState(() {
                // 1. Reset the workout data (sets, reps, weights)
                _workout = widget.workout.copyWith();

                // 2. Reset the list of exercises itself
                _exercises = List.from(widget.exercises);
              });
            },
            child: const Icon(Icons.restart_alt),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: "done",
            tooltip: "Edit",
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await _workoutsService.updateWorkout(_workout);
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Icon(Icons.done),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: "cancel",
            tooltip: "Cancel",
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.clear),
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text(
          "Edit Workout",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: ReorderableListView(
        buildDefaultDragHandles: false, // Prevents gesture conflicts
        footer: Center(
          child: TextButton(
            onPressed: () => BottomAddExercisePopup.showPopup(
              context,
              (workoutId) => addExercise(workoutId),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "+ Add Exercise",
                style: TextStyle(
                  color: AppPalette.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        children: [
          // ✨ Wrapped the EditTile with a Dismissible
          for (int i = 0; i < _exercises.length; i++)
            Dismissible(
              // The key is essential for both Dismissible and ReorderableListView
              key: ValueKey(_exercises[i].id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                deleteExercise(i);
              },
              background: Container(
                decoration: BoxDecoration(
                  color: AppPalette.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                // Match the margin of EditTile for consistent appearance
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: AppPalette.onError),
              ),
              child: EditTile(
                // Note: The key is now on the parent Dismissible for the ReorderableListView
                exerciseSession: _workout.exercises[i],
                exercise: _exercises[i],
                index: i,
                onUpdate: (setIndex, reps, weight) =>
                    updateSet(i, setIndex, reps: reps, weight: weight),
                onDeleteSet: (setIndex) => deleteSet(i, setIndex),
                onAdd: () => addSet(i),
                setStateFunction: setStateWhenClosed,
              ),
            ),
        ],
        onReorder: (oldIndex, newIndex) {
          setState(() {
            // This adjustment is needed when moving an item downwards
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }

            // Reorder the local list of Exercise models
            final exerciseItem = _exercises.removeAt(oldIndex);
            _exercises.insert(newIndex, exerciseItem);

            // Reorder the list of ExerciseSessions within the workout state
            final updatedExercises = List<ExerciseSession>.from(
              _workout.exercises,
            );
            final workoutItem = updatedExercises.removeAt(oldIndex);
            updatedExercises.insert(newIndex, workoutItem);

            _workout = _workout.copyWith(exercises: updatedExercises);
          });
        },
      ),
    );
  }
}
