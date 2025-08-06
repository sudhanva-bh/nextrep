import 'package:nextrep/core/constants/file_paths.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';
import 'package:nextrep/core/entities/workout/exercise_set.dart';
import 'package:nextrep/core/entities/workout/workout.dart';

class PresetWorkouts {
  static final List<Workout> workouts = [
    // Arm Workouts
    Workout(
      workoutName: "Arms Workout",
      exercises: [
        ExerciseSession(
          workoutId: "0416", // dumbbell standing biceps curl
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 20),
          ),
        ),
        ExerciseSession(
          workoutId: "0430", // dumbbell standing triceps extension
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 10),
          ),
        ),
        ExerciseSession(
          workoutId: "1659", // dumbbell hammer curl
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 20),
          ),
        ),
        ExerciseSession(
          workoutId: "0241", // cable triceps pushdown (v-bar)
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 10),
          ),
        ),
        ExerciseSession(
          workoutId: "0297", // dumbbell concentration curl
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 20),
          ),
        ),
        ExerciseSession(
          workoutId: "1721", // barbell reverse grip skullcrusher
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 10),
          ),
        ),
      ],
      imagePath: WorkoutImagePaths.arms2,
    ),

    // Chest Workouts
    Workout(
      workoutName: "Chest Workout",
      exercises: [
        ExerciseSession(
          workoutId: "0025", // barbell bench press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0047", // barbell incline bench press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0047", // barbell incline bench press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0047", // barbell incline bench press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0047", // barbell incline bench press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0047", // barbell incline bench press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
      ],
      imagePath: WorkoutImagePaths.chest,
    ),
  ];
}
