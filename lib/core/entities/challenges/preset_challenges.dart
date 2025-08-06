import 'package:nextrep/core/constants/file_paths.dart';
import 'package:nextrep/core/entities/challenges/challenge.dart';

final List<Challenge> presetChallenges = [
  Challenge(
    title: 'Walk\nEvery Day for Health',
    description:
        'Go for a walk every day to stay active and improve overall health.',
    totalDays: 30,
    imagePath: WorkoutImagePaths.walking,
  ),
  Challenge(
    title: 'Meditate Every Day for Peace',
    description:
        'Spend time meditating daily to reduce stress and improve focus.',
    totalDays: 30,
    imagePath: WorkoutImagePaths.meditate,
  ),
  Challenge(
    title: 'Sleep Reset – 8 Hours a Night',
    description: 'Sleep for 8 hours and avoid screens 30 mins before bedtime.',
    totalDays: 7,
    imagePath: WorkoutImagePaths.sleep,
  ),
  Challenge(
    title: 'Pushups Every Day for Strength',
    description: 'Build upper body strength with daily pushup sessions.',
    totalDays: 21,
    imagePath: WorkoutImagePaths.pushup,
  ),
  Challenge(
    title: 'Stretch Every Morning for Flexibility',
    description:
        'Start your day with a quick full-body stretch to stay limber.',
    totalDays: 15,
    imagePath: WorkoutImagePaths.stretch,
  ),
  Challenge(
    title: 'Limit Sugar Every Day for Lifestyle',
    description:
        'Avoid added sugars daily for a healthier and cleaner lifestyle.',
    totalDays: 30,
    imagePath: WorkoutImagePaths.sugar,
  ),
  Challenge(
    title: 'Hydration Hero Drink 3L water Daily',
    description:
        'Drink at least 2 to 3 liters of water daily to stay hydrated.',
    totalDays: 10,
    imagePath: WorkoutImagePaths.water,
  ),
];
