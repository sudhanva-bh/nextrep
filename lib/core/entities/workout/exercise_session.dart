// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:nextrep/core/entities/workout/exercise_set.dart';

part 'exercise_session.g.dart';

@HiveType(typeId: 3)
class ExerciseSession extends HiveObject {
  @HiveField(0)
  final String workoutId;

  @HiveField(1)
  final List<ExerciseSet> sets;

  ExerciseSession({
    required this.workoutId,
    required this.sets,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workoutId': workoutId,
      'sets': sets.map((x) => x.toMap()).toList(),
    };
  }

  factory ExerciseSession.fromMap(Map<String, dynamic> map) {
    return ExerciseSession(
      workoutId: map['workoutId'] as String,
      sets: List<ExerciseSet>.from(
        (map['sets'] as List).map(
          (x) => ExerciseSet.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseSession.fromJson(String source) =>
      ExerciseSession.fromMap(json.decode(source) as Map<String, dynamic>);
}
