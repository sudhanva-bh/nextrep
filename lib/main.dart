// // php -S localhost:8000 -c C:\php\php.ini-development api.php

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/auth_wrapper.dart';
import 'package:nextrep/core/services/challenges/challenges_service.dart';
import 'package:nextrep/core/services/hive_init_service.dart';
import 'package:nextrep/core/theme/theme.dart';
import 'package:nextrep/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrintStack(label: "🔥 HiveError Trace", stackTrace: details.stack);
  };

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await HiveInitService.initHive();

  ChallengesService().putPresetChallenges();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
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

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:nextrep/core/services/exercises/exercise_raw_data_service.dart';
// import 'package:nextrep/core/services/hive_init_service.dart';
// import 'package:nextrep/core/theme/app_palette.dart';
// import 'package:nextrep/features/preview_workout/presentation/data/fetch_target_part_images.dart';
// import 'package:nextrep/features/preview_workout/presentation/utils/bottom_workout_preview_popup.dart';
// import 'package:nextrep/features/preview_workout/presentation/utils/consequtive_images.dart';

// Future<void> main() async {
//   await HiveInitService.initHive();

//   await dotenv.load(fileName: ".env");
//   runApp(const TestApp());
// }

// class TestApp extends StatelessWidget {
//   const TestApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: AppPalette.background,
//       ),
//       home: const TestYouTubeEmbed(),
//     );
//   }
// }

// class TestYouTubeEmbed extends StatelessWidget {
//   const TestYouTubeEmbed({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final exercise = ExerciseService().getExerciseById("0020");
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // SizedBox(
//             //   width: 400,
//             //   child: YouTubeEmbed(
//             //     exercise: ExerciseService().getExerciseById("0416"),
//             //   ),
//             // ),
//             MuscleApiService().getMuscleImageWidgetBuilder(exercise),
//             ElevatedButton(
//               onPressed: () => BottomWorkoutPreviewPopup(
//                 exercise: exercise,
//               ).showPopup(context),
//               child: Icon(Icons.abc),
//             ),
//             ConsecutiveImages(
//               firstImagePath: exercise.image0,
//               secondImagePath: exercise.image1,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
