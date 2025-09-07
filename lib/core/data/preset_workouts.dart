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
      imagePath: WorkoutImagePaths.arms,
    ),

    // Push Day
    Workout(
      workoutName: "Push Day",
      exercises: [
        ExerciseSession(
          workoutId: "0576", // Chest Press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0753", // Decline Bench Press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0757", // Incline Bench Press
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
          workoutId: "0596", // Seated Fly
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "1451", // Seated Dip
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0333", // Kickback
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0087", // Seated Shoulder Press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0199", // Lower Arm Extension
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0389", // Seated Bench Extension
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0423", // Standing One Arm Lift
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0464", // Twist And Hold
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
      ],
      imagePath: WorkoutImagePaths.chest,
    ),

    // Pull Day
    Workout(
      workoutName: "Pull Day",
      exercises: [
        ExerciseSession(
          workoutId: "0150", // Bar Lateral Pulldown
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "1350", // Seated Row
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "2298", // Incline Row
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0095", // Shrug
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0592", // Preacher Curl
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "1659", // Hammer Curl
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0032", // Deadlift
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
      ],
      imagePath: WorkoutImagePaths.back,
    ),
    // Legs
    Workout(
      workoutName: "Leg Day",
      exercises: [
        ExerciseSession(
          workoutId: "0043", // Full squat
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0585", // Leg Extension
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0586", // Lying Leg Curl
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0594", // Seated Calf Raise
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0175", // Kneeling Crunch
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
      ],
      imagePath: WorkoutImagePaths.legs,
    ),

    // Upper Body
    Workout(
      workoutName: "Upper Body",
      exercises: [
        ExerciseSession(
          workoutId: "0289", // Bench Press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0301", // Decline Bench Press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0314", // Incline Bench Press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0596", // Seated Fly
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0150", // Bar Lateral Pulldown
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0159", // Decline Seated Row
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0220", // Shrug
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
      ],
      imagePath: WorkoutImagePaths.stretch,
    ),
  ];

  static final List<Workout> favourites = [
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
      imagePath: WorkoutImagePaths.arms,
    ),

    // Push Day
    Workout(
      workoutName: "Push Day",
      exercises: [
        ExerciseSession(
          workoutId: "0576", // Chest Press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0753", // Decline Bench Press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0757", // Incline Bench Press
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
          workoutId: "0596", // Seated Fly
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "1451", // Seated Dip
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0333", // Kickback
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0087", // Seated Shoulder Press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0199", // Lower Arm Extension
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0389", // Seated Bench Extension
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0423", // Standing One Arm Lift
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0464", // Twist And Hold
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
      ],
      imagePath: WorkoutImagePaths.chest,
    ),

    // Pull Day
    Workout(
      workoutName: "Pull Day",
      exercises: [
        ExerciseSession(
          workoutId: "0150", // Bar Lateral Pulldown
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "1350", // Seated Row
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "2298", // Incline Row
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0095", // Shrug
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0592", // Preacher Curl
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "1659", // Hammer Curl
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0032", // Deadlift
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
      ],
      imagePath: WorkoutImagePaths.back,
    ),
    // Legs
    Workout(
      workoutName: "Leg Day",
      exercises: [
        ExerciseSession(
          workoutId: "0043", // Full squat
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0585", // Leg Extension
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0586", // Lying Leg Curl
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0594", // Seated Calf Raise
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0175", // Kneeling Crunch
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
      ],
      imagePath: WorkoutImagePaths.legs,
    ),

    // Upper Body
    Workout(
      workoutName: "Upper Body",
      exercises: [
        ExerciseSession(
          workoutId: "0289", // Bench Press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0301", // Decline Bench Press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0314", // Incline Bench Press
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0596", // Seated Fly
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0150", // Bar Lateral Pulldown
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0159", // Decline Seated Row
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
        ExerciseSession(
          workoutId: "0220", // Shrug
          sets: List<ExerciseSet>.generate(
            4,
            (_) => ExerciseSet(reps: 12, weight: 30),
          ),
        ),
      ],
      imagePath: WorkoutImagePaths.stretch,
    ),
  ];
}
