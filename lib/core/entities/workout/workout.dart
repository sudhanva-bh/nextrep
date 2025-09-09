// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
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

  @HiveField(3, defaultValue: false) // ✅ New field with default value
  final bool isFavourite;

  Workout({
    required this.workoutName,
    required this.exercises,
    required this.imagePath,
    this.isFavourite = false, // ✅ default false
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workoutName': workoutName,
      'exercises': exercises.map((x) => x.toMap()).toList(),
      'imagePath': imagePath,
      'isFavourite': isFavourite,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      workoutName: map['workoutName'] as String,
      exercises: List<ExerciseSession>.from(
        (map['exercises'] as List).map(
          (x) => ExerciseSession.fromMap(x as Map<String, dynamic>),
        ),
      ),
      imagePath: map['imagePath'] as String,
      isFavourite: map['isFavourite'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Workout.fromJson(String source) =>
      Workout.fromMap(json.decode(source) as Map<String, dynamic>);

  Workout copyWith({
    String? workoutName,
    List<ExerciseSession>? exercises,
    String? imagePath,
    bool? isFavourite,
  }) {
    return Workout(
      workoutName: workoutName ?? this.workoutName,
      exercises: exercises ?? this.exercises,
      imagePath: imagePath ?? this.imagePath,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  @override
  String toString() {
    final exerciseIds = exercises.map((e) => e.workoutId).join(', ');

    return 'Workout(workoutName: $workoutName, '
        'exercises: [$exerciseIds], '
        'isFavourite: $isFavourite)';
  }
}
