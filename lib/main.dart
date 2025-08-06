import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nextrep/auth_wrapper.dart';
import 'package:nextrep/core/services/exercises/workout_hive_sync.dart';
import 'package:nextrep/core/services/exercises/exercise_raw_data_hive_sync.dart';
import 'package:nextrep/core/theme/theme.dart';
import 'package:nextrep/core/entities/user/user_profile_model.dart';
import 'package:nextrep/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  Hive.registerAdapter(UserProfileAdapter());
  await Hive.openBox<UserProfile>('user_profile');

  // await Hive.deleteBoxFromDisk('exercisesBox');
  // await Hive.deleteBoxFromDisk('workoutsBox');

  await ExerciseHiveSync.cacheExercisesToHive();
  await ExerciseModelHiveSync.exerciseModelsToHive();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NextRep",
      theme: AppTheme.darkTheme,

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },

      home: AuthWrapper(),
    );
  }
}
