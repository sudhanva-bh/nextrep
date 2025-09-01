import 'package:hive/hive.dart';
import 'package:nextrep/core/entities/workout/workout.dart';

part 'favourite_workout.g.dart';

@HiveType(typeId: 6) // give a unique typeId
class FavouriteWorkout extends HiveObject {
  @HiveField(0)
  final String id; // unique ID for favourite
  @HiveField(1)
  final Workout workout;

  FavouriteWorkout({
    required this.id,
    required this.workout,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workout': workout.toMap(),
    };
  }

  factory FavouriteWorkout.fromJson(Map<String, dynamic> json) {
    return FavouriteWorkout(
      id: json['id'] as String,
      workout: Workout.fromMap(json['workout'] as Map<String, dynamic>),
    );
  }
}
