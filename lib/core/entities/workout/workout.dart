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

  Workout({
    required this.workoutName,
    required this.exercises,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workoutName': workoutName,
      'exercises': exercises.map((x) => x.toMap()).toList(),
      'imagePath': imagePath,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Workout.fromJson(String source) =>
      Workout.fromMap(json.decode(source) as Map<String, dynamic>);
}
