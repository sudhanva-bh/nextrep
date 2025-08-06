import 'package:hive/hive.dart';
import 'package:nextrep/core/entities/workout/exercise_set.dart';

part 'exercise_session.g.dart';

@HiveType(typeId: 3)
class ExerciseSession extends HiveObject{
  @HiveField(0)
  final String workoutId;

  @HiveField(1)
  final List<ExerciseSet> sets;

  ExerciseSession({
    required this.workoutId,
    required this.sets,
  });
}
