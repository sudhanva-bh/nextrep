// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:hive/hive.dart';

part 'exercise_model.g.dart';

@HiveType(typeId: 1)
class Exercise extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String bodyPart;

  @HiveField(5)
  final String targetMuscle; // mapped from 'target' in JSON

  @HiveField(6)
  final List<String> secondaryMuscles;

  @HiveField(7)
  final String image0;

  @HiveField(8)
  final String image1;

  @HiveField(9)
  final List<String> instructions;

  @HiveField(10)
  final String difficulty;

  @HiveField(11)
  final String equipment;

  @HiveField(12)
  final String? nickname;
  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.bodyPart,
    required this.targetMuscle,
    required this.secondaryMuscles,
    required this.image0,
    required this.image1,
    required this.instructions,
    required this.difficulty,
    required this.equipment,
    required this.nickname,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'bodyPart': bodyPart,
      'targetMuscle': targetMuscle,
      'secondaryMuscles': secondaryMuscles,
      'image0': image0,
      'image1': image1,
      'instructions': instructions,
      'difficulty': difficulty,
      'equipment': equipment,
      'nickname': nickname,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      bodyPart: map['bodyPart'] as String,
      targetMuscle: map['target'] as String,
      secondaryMuscles: List<String>.from(map['secondaryMuscles'] ?? []),
      image0: map['image0'] as String,
      image1: map['image1'] as String,
      instructions: List<String>.from(map['instructions'] ?? []),
      difficulty: map['difficulty'] as String,
      equipment: map['equipment'] as String,
      nickname: map['nickname'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Exercise.fromJson(String source) =>
      Exercise.fromMap(json.decode(source) as Map<String, dynamic>);
}

