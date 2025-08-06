// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double height;

  @HiveField(2)
  final double weight;

  @HiveField(5)
  final double? targetWeight;

  @HiveField(3)
  final String experience;

  @HiveField(4)
  final String gender;

  UserProfile({
    required this.name,
    required this.height,
    required this.weight,
    required this.experience,
    required this.gender,
    this.targetWeight
  });

  // For syncing with Firebase later
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? '',
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(),
      experience: map['experience'] ?? '',
      gender: map['gender'] ?? '',
      targetWeight: map['targetWeight'],
    );
  }

  UserProfile copyWith({
    String? name,
    double? height,
    double? weight,
    String? experience,
    String? gender,
    double? targetWeight
  }) {
    return UserProfile(
      name: name ?? this.name,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      experience: experience ?? this.experience,
      gender: gender ?? this.gender,
      targetWeight: targetWeight ?? this.targetWeight,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'height': height,
      'weight': weight,
      'experience': experience,
      'targetWeight': targetWeight,
    };
  }
}
