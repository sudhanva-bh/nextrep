import 'package:hive/hive.dart';

part 'challenge.g.dart';

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
  List<bool> dailyProgress;

  Challenge({
    required this.title,
    required this.description,
    required this.totalDays,
    required this.imagePath,
    List<bool>? dailyProgress,
  }) : dailyProgress =
            dailyProgress ?? List.generate(totalDays, (_) => false) {
    assert(this.dailyProgress.length == totalDays,
        'dailyProgress list length must equal totalDays.');
  }

  int get daysDone => dailyProgress.where((done) => done).length;

  bool get isCompleted => daysDone >= totalDays;

  double get progress {
    if (totalDays == 0) return 0.0;
    return (daysDone / totalDays).clamp(0.0, 1.0);
  }

  void toggleDay(int dayIndex) {
    if (dayIndex >= 0 && dayIndex < totalDays) {
      dailyProgress[dayIndex] = !dailyProgress[dayIndex];
    }
  }

  void restartChallenge() {
    dailyProgress = List.generate(totalDays, (_) => false);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'totalDays': totalDays,
      'imagePath': imagePath,
      // ✨ Use the new list for serialization
      'dailyProgress': dailyProgress,
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    final progressFromJson = json['dailyProgress'] as List<dynamic>?;
    final dailyProgress = progressFromJson?.map((e) => e as bool).toList();

    return Challenge(
      title: json['title'] as String,
      description: json['description'] as String,
      totalDays: json['totalDays'] as int,
      imagePath: json['imagePath'] as String,
      dailyProgress: dailyProgress,
    );
  }
}
