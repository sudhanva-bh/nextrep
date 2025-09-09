import 'package:hive/hive.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double height;

  // 👇 Now a list of weight entries instead of a single double
  @HiveField(2)
  final List<WeightEntry> weightHistory;

  @HiveField(5)
  final double? targetWeight;

  @HiveField(3)
  final String experience;

  @HiveField(4)
  final String gender;

  UserProfile({
    required this.name,
    required this.height,
    required this.weightHistory,
    required this.experience,
    required this.gender,
    this.targetWeight,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? '',
      height: (map['height'] ?? 0).toDouble(),
      weightHistory: (map['weightHistory'] as List<dynamic>? ?? [])
          .map(
            (e) => WeightEntry(
              date: DateTime.parse(e['date']),
              weight: (e['weight'] as num).toDouble(),
            ),
          )
          .toList(),
      experience: map['experience'] ?? '',
      gender: map['gender'] ?? '',
      targetWeight: (map['targetWeight'] as num?)?.toDouble(),
    );
  }

  UserProfile copyWith({
    String? name,
    double? height,
    List<WeightEntry>? weightHistory,
    String? experience,
    String? gender,
    double? targetWeight,
  }) {
    return UserProfile(
      name: name ?? this.name,
      height: height ?? this.height,
      weightHistory: weightHistory ?? this.weightHistory,
      experience: experience ?? this.experience,
      gender: gender ?? this.gender,
      targetWeight: targetWeight ?? this.targetWeight,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'height': height,
      'weightHistory': weightHistory
          .map(
            (entry) => {
              'date': entry.date.toIso8601String(),
              'weight': entry.weight,
            },
          )
          .toList(),
      'experience': experience,
      'gender': gender,
      'targetWeight': targetWeight,
    };
  }
}

@HiveType(typeId: 6)
class WeightEntry {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double weight;

  WeightEntry({
    required this.date,
    required this.weight,
  });
}
