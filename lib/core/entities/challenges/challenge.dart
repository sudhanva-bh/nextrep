import 'package:hive/hive.dart';

part 'challenge.g.dart'; // This file will be generated

@HiveType(typeId: 5)
class Challenge extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final int totalDays;

  @HiveField(3)
  final String imagePath;

  @HiveField(4)
  int daysDone;

  Challenge({
    required this.title,
    required this.description,
    required this.totalDays,
    required this.imagePath,
    this.daysDone = 0,
  });

  /// Automatically computed getter
  bool get isCompleted => daysDone >= totalDays;

  /// Progress from 0.0 to 1.0
  double get progress => daysDone / totalDays;

  void increaseDaysDone() {
    if (!isCompleted) {
      daysDone++;
    }
  }

  void restartChallenge() {
    daysDone = 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'totalDays': totalDays,
      'imagePath': imagePath,
      'daysDone': daysDone,
    };
  }

  /// Converts the Challenge object into a Map (for Hive or JSON)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'totalDays': totalDays,
      'imagePath': imagePath,
      'daysDone': daysDone,
    };
  }

  /// Creates a Challenge object from a Map (e.g., Firebase or JSON)
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      title: json['title'] as String,
      description: json['description'] as String,
      totalDays: json['totalDays'] as int,
      imagePath: json['imagePath'] as String,
      daysDone: (json['daysDone'] ?? 0) as int,
    );
  }
}
