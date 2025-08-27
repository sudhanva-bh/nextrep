// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reps': reps,
      'weight': weight,
    };
  }

  factory ExerciseSet.fromMap(Map<String, dynamic> map) {
    return ExerciseSet(
      reps: map['reps'] as int,
      weight: map['weight'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseSet.fromJson(String source) => ExerciseSet.fromMap(json.decode(source) as Map<String, dynamic>);
}
