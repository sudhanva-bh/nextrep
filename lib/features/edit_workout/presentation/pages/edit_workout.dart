import 'package:flutter/material.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';
import 'package:nextrep/core/entities/workout/exercise_set.dart';
import 'package:nextrep/core/entities/workout/workout.dart';
import 'package:nextrep/core/services/exercises/workouts_service.dart';
import 'package:nextrep/features/edit_workout/presentation/widgets/edit_tile.dart';

class EditWorkout extends StatefulWidget {
  const EditWorkout({
    super.key,
    required this.workout,
    required this.exercises,
  });

  final Workout workout;
  final List<Exercise> exercises;

  @override
  State<EditWorkout> createState() => _EditWorkoutState();
}

class _EditWorkoutState extends State<EditWorkout> {
  late List<Exercise> _exercises; // local copy so we can reorder
  late Workout _workout;
  late WorkoutsService _workoutsService;

  @override
  void initState() {
    super.initState();
    _workoutsService = WorkoutsService();
    _exercises = List.from(widget.exercises); // clone list
    _workout = widget.workout.copyWith();
  }

  void setStateWhenClosed() {
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "refresh",
            tooltip: "Refresh",
            onPressed: () {
              setState(() {
                _workout = widget.workout.copyWith();
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
        footer: const Card(
          margin: EdgeInsets.all(8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text("Test Card in Footer"),
          ),
        ),
        children: [
          for (int i = 0; i < _exercises.length; i++)
            EditTile(
              // The key is essential for ReorderableListView to work correctly
              key: ValueKey(_exercises[i].id),
              exerciseSession: _workout.exercises[i],
              exercise: _exercises[i],
              index: i,
              onUpdate: (setIndex, reps, weight) =>
                  updateSet(i, setIndex, reps: reps, weight: weight),
              onDeleteSet: (setIndex) => deleteSet(i, setIndex),
              onAdd: () => addSet(i),
              setStateFunction: setStateWhenClosed,
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
