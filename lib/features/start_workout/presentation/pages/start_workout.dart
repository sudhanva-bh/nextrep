import 'package:flutter/material.dart';
import 'package:nextrep/core/common/utils/show_snackbar.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';
import 'package:nextrep/core/entities/workout/exercise_set.dart';
import 'package:nextrep/core/entities/workout/workout.dart';
import 'package:nextrep/core/services/exercises/exercise_raw_data_service.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/edit_workout/presentation/pages/add_exercise/add_exercise.dart';
import 'package:nextrep/features/start_workout/presentation/widgets/current_workout.dart';
import 'package:nextrep/features/start_workout/presentation/widgets/end_workout_dialog.dart';
import 'package:nextrep/features/start_workout/presentation/widgets/exercise_session_card.dart';
import 'package:nextrep/features/start_workout/presentation/widgets/exercise_timer.dart';

class StartWorkout extends StatefulWidget {
  final Workout workout;
  final DateTime startTime;

  const StartWorkout({
    super.key,
    required this.workout,
    required this.startTime,
  });

  @override
  State<StartWorkout> createState() => _StartWorkoutState();
}

class _StartWorkoutState extends State<StartWorkout> {
  final _exerciseService = ExerciseService();
  late Workout _workout;
  late List<Exercise> _exercises;

  late int _currentExerciseIndex;
  late ExerciseSession _currentExerciseSession;
  late Exercise _currentExercise;

  late List<bool> _workoutsDone;
  late List<List<bool>> _setsDone;
  late ScrollController _scrollController;

  void _saveWorkout() {
    showSnackBar(context, 'Workout changes have been saved!');
    // Example: await myWorkoutRepository.updateWorkout(_workout);
  }

  // REPLACE the old _showEndWorkoutDialogs method with this new, cleaner one.
  Future<void> _endWorkout() async {
    final result = await EndWorkoutDialog.show(
      context,
      workoutsDone: _workoutsDone,
      setsDone: _setsDone,
    );

    // If the user cancelled or the widget is no longer visible, do nothing.
    if (result == null || !mounted) return;

    // Handle the result from the dialog.
    switch (result) {
      case EndWorkoutResult.save:
        _saveWorkout();
        Navigator.of(context).pop();
        break;
      case EndWorkoutResult.discard:
        showSnackBar(context, 'Workout changes were not saved.');
        Navigator.of(context).pop();
        break;
    }
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

      _workoutsDone.add(false);
      _setsDone.add([false]);
    });
  }

  void deleteExercise(int index) {
    if (_exercises.length <= 1) {
      showSnackBar(
        context,
        "You can't delete the last exercise from a workout.",
      );
      return;
    }

    setState(() {
      _exercises.removeAt(index);
      _workout.exercises.removeAt(index);
      _workoutsDone.removeAt(index);
      _setsDone.removeAt(index);

      if (_currentExerciseIndex >= _exercises.length) {
        _currentExerciseIndex = _exercises.length - 1;
      }

      _currentExercise = _exercises[_currentExerciseIndex];
      _currentExerciseSession = _workout.exercises[_currentExerciseIndex];
    });
  }

  /// Updates the reps or weight for a specific set of the current exercise.
  void updateCurrentSet(
    int setIndex, {
    required int reps,
    required double weight,
  }) {
    setState(() {
      final currentSets = _workout.exercises[_currentExerciseIndex].sets;
      final oldSet = currentSets[setIndex];
      currentSets[setIndex] = oldSet.copyWith(
        reps: reps,
        weight: weight,
      );
    });
  }

  /// Adds a new set to the current exercise.
  void addCurrentSet() {
    setState(() {
      final currentSets = _workout.exercises[_currentExerciseIndex].sets;
      // Add a new set, copying the last one's values or using defaults.
      final newSet = currentSets.isNotEmpty
          ? currentSets.last.copyWith()
          : ExerciseSet(reps: 8, weight: 10);
      currentSets.add(newSet);

      // Also update the _setsDone list to track the new set.
      _setsDone[_currentExerciseIndex].add(false);
    });
  }

  /// Deletes a set from the current exercise.
  void deleteCurrentSet(int setIndex) {
    setState(() {
      _workout.exercises[_currentExerciseIndex].sets.removeAt(setIndex);
      _setsDone[_currentExerciseIndex].removeAt(setIndex);
    });
  }

  List<Exercise> _getExercises(Workout workout) {
    return workout.exercises
        .map((s) => _exerciseService.getExerciseById(s.workoutId))
        .toList();
  }

  Future<void> changeWorkoutSetState(int workout, int set) async {
    setState(() {
      _setsDone[workout][set] = !_setsDone[workout][set];
    });

    if (_setsDone[workout].every((done) => done)) {
      _workoutsDone[workout] = true;
      await Future.delayed(Duration(milliseconds: 1000));
      changeCurrentExercise(_currentExerciseIndex + 1);
    }
  }

  Future<void> changeWorkoutState(int workout) async {
    setState(() {
      _workoutsDone[workout] = !_workoutsDone[workout];
      _setsDone[workout] = List.generate(
        _setsDone[workout].length,
        (_) => _workoutsDone[workout],
      );
    });
    if (workout == _currentExerciseIndex &&
        _workoutsDone[workout] &&
        _currentExerciseIndex < _exercises.length) {
      await Future.delayed(Duration(milliseconds: 1000));
      changeCurrentExercise(_currentExerciseIndex + 1);
    }
  }

  Future<void> changeCurrentExercise(int changeToIndex) async {
    if (changeToIndex >= 0 && changeToIndex < _exercises.length) {
      setState(() {
        _currentExerciseIndex = changeToIndex;
        _currentExerciseSession = _workout.exercises[_currentExerciseIndex];
        _currentExercise = _exercises[_currentExerciseIndex];
      });

      await Future.delayed(Duration(milliseconds: 200));

      _scrollController.animateTo(
        340, // top position
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _workout = widget.workout.copyWith(
      exercises: widget.workout.exercises
          .map(
            (session) => session.copyWith(
              sets: List<ExerciseSet>.from(session.sets),
            ),
          )
          .toList(),
    );

    _exercises = _getExercises(_workout);
    _currentExerciseIndex = 0;
    _currentExerciseSession = _workout.exercises[_currentExerciseIndex];
    _currentExercise = _exercises[_currentExerciseIndex];

    _workoutsDone = List.generate(_exercises.length, (_) => false);
    _setsDone = [];

    for (int i = 0; i < _exercises.length; i++) {
      _setsDone.add(
        List.generate(_workout.exercises[i].sets.length, (_) => false),
      );
    }

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        _endWorkout();
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          // Call the new, cleaner function
          onPressed: _endWorkout,
          icon: const Icon(Icons.stop_circle_outlined),
          label: const Text('End Workout'),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              collapsedHeight: 70,
              expandedHeight: 400,
              backgroundColor: AppPalette.surface,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    _workout.workoutName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_workout.imagePath),
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
            SliverPersistentHeader(
              pinned: true,
              delegate: _TimerHeaderDelegate(
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    ExerciseTimer(
                      startTime: widget.startTime,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    CurrentWorkout(
                      exercise: _currentExercise,
                      exerciseSession: _currentExerciseSession,
                      setsDone: _setsDone[_currentExerciseIndex],
                      onToggle: (setIndex) => changeWorkoutSetState(
                        _currentExerciseIndex,
                        setIndex,
                      ),
                      onAddSet: addCurrentSet,
                      onDeleteSet: deleteCurrentSet,
                      onUpdateSet: (setIndex, reps, weight) => updateCurrentSet(
                        setIndex,
                        reps: reps,
                        weight: weight,
                      ),
                    ),

                    SizedBox(height: 12),

                    for (int i = 0; i < _workout.exercises.length; i++) ...[
                      // ✨ Wrap the card with the Dismissible widget
                      Dismissible(
                        key: ValueKey(
                          _exercises[i].id,
                        ), // A unique key is mandatory for Dismissible
                        direction: DismissDirection
                            .endToStart, // Allow swiping from right to left
                        onDismissed: (direction) {
                          // Call your new delete function when the item is swiped away
                          deleteExercise(i);
                        },
                        // This is the background that appears during the swipe
                        background: Container(
                          decoration: BoxDecoration(
                            color: AppPalette.error,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: const Icon(
                            Icons.delete_outline,
                            color: AppPalette.onError,
                            size: 30,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () => changeCurrentExercise(i),
                          child: StartExerciseSessionCard(
                            exercise: _exercises[i],
                            exerciseSession: _workout.exercises[i],
                            isDone: _workoutsDone[i],
                            onToggle: () => changeWorkoutState(i),
                            isSelected: i == _currentExerciseIndex,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextButton(
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _TimerHeaderDelegate({
    required this.child,
    // ignore: unused_element_parameter
    this.height = 72,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.transparent,
      child: Center(child: child),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
