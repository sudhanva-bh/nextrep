import 'package:hive/hive.dart';

part 'exercise_set.g.dart';

@HiveType(typeId: 2)
class ExerciseSet extends HiveObject {
  @HiveField(0)
  final int reps;

  @HiveField(1)
  final double weight;

  ExerciseSet({
    required this.reps,
    required this.weight,
  });
}
