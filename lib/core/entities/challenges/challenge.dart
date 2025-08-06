class Challenge {
  final String title;
  final String description;
  final int totalDays;
  final String imagePath;
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
}
