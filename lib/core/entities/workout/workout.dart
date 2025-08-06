import 'package:hive/hive.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';

part 'workout.g.dart';

@HiveType(typeId: 4)
class Workout extends HiveObject {
  @HiveField(0)
  final String workoutName;

  @HiveField(1)
  final List<ExerciseSession> exercises;

  @HiveField(2)
  final String imagePath;

  Workout({
    required this.workoutName,
    required this.exercises,
    required this.imagePath,
  });
}
