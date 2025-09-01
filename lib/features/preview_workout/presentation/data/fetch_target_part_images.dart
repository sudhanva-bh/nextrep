import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class MuscleApiService {
  final String baseUrl =
      'https://muscle-localised-api.netlify.app/.netlify/functions/';
  final Box<Uint8List> cacheBox = Hive.box<Uint8List>('muscle_images');

  String colorToRgbString(Color color) {
    return '${color.red},${color.green},${color.blue}';
  }

  static const Map<String, String> targetMap = {
    "abductors": "abductors",
    "abs": "abs",
    "adductors": "adductors",
    "biceps": "biceps",
    "calves": "calfs",
    "cardiovascular system": "all",
    "delts": "shoulders",
    "forearms": "forearms",
    "glutes": "gluteus",
    "hamstrings": "hamstring",
    "lats": "latissimus",
    "levator scapulae": "neck",
    "pectorals": "chest",
    "quads": "quadriceps",
    "serratus anterior": "core_upper",
    "spine": "back_lower",
    "traps": "shoulders_back",
    "triceps": "triceps",
    "upper back": "back_upper",
  };

  static const Map<String, String> secondaryMap = {
    "abdominals": "abs",
    "ankle stabilizers": "legs",
    "ankles": "legs",
    "back": "back",
    "biceps": "biceps",
    "brachialis": "biceps",
    "calves": "calfs",
    "chest": "chest",
    "core": "core",
    "deltoids": "shoulders",
    "feet": "legs",
    "forearms": "forearms",
    "glutes": "gluteus",
    "grip muscles": "hands",
    "groin": "legs",
    "hamstrings": "hamstring",
    "hands": "hands",
    "hip flexors": "core_lower",
    "inner thighs": "legs",
    "latissimus dorsi": "latissimus",
    "lats": "latissimus",
    "lower abs": "core_lower",
    "lower back": "back_lower",
    "obliques": "core",
    "quadriceps": "quadriceps",
    "rear deltoids": "shoulders_back",
    "rhomboids": "back_upper",
    "rotator cuff": "shoulders",
    "shins": "legs",
    "shoulders": "shoulders_front",
    "soleus": "calfs",
    "sternocleidomastoid": "neck",
    "trapezius": "shoulders_back",
    "traps": "shoulders_back",
    "triceps": "triceps",
    "upper back": "back_upper",
    "upper chest": "chest",
    "wrist extensors": "forearms",
    "wrist flexors": "forearms",
    "wrists": "hands",
  };

  Future<Image> getMuscleImageWidget(
    Exercise exercise, {
    bool transparent = false,
  }) async {
    // Map primary muscle
    String mappedPrimary =
        targetMap[exercise.targetMuscle] ?? exercise.targetMuscle;

    // Map secondary muscles
    List<String> mappedSecondary = exercise.secondaryMuscles
        .map((m) => secondaryMap[m] ?? m)
        .toList();

    // Remove duplicates that are same as primary
    mappedSecondary.removeWhere((m) => m == mappedPrimary);

    // Cache key
    String cacheKey =
        'muscle_image_${exercise.id}_${mappedPrimary}_${mappedSecondary.join("_")}_transparent_${transparent ? 1 : 0}';

    // Check Hive cache
    if (cacheBox.containsKey(cacheKey)) {
      final cachedBytes = cacheBox.get(cacheKey)!;
      return Image.memory(cachedBytes, fit: BoxFit.contain);
    }

    // Colors in R,G,B format for PHP
    String primaryColor = colorToRgbString(AppPalette.primary);
    String secondaryColor = colorToRgbString(const Color(0xFFFFC977));

    // Build API URL
    final uri = Uri.parse(
      '${baseUrl}muscle-image'
      '?primary_muscles=${Uri.encodeComponent(mappedPrimary)}'
      '&secondary_muscles=${Uri.encodeComponent(mappedSecondary.join(","))}'
      '&primary_color=$primaryColor'
      '&secondary_color=$secondaryColor'
      '&transparent=${transparent ? 1 : 0}',
    );

    // HTTP GET
    final response = await http.get(
      uri,
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
      },
    );

    if (response.statusCode == 200) {
      // Check if content is an image
      if (response.headers['content-type']?.contains('image') == true) {
        final bytes = response.bodyBytes;
        await cacheBox.put(cacheKey, bytes);
        return Image.memory(bytes, fit: BoxFit.contain);
      } else {
        throw Exception('API did not return an image: ${response.body}');
      }
    } else {
      throw Exception(
        'Failed to fetch muscle image: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }

  Widget getMuscleImageWidgetBuilder(
    Exercise exercise, {
    bool transparent = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPalette.outlineEnabled),
      ),
      width: 120,
      height: 120,
      child: FutureBuilder<Image>(
        future: getMuscleImageWidget(exercise, transparent: transparent),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: const Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const SizedBox.shrink(); // fallback
          }
        },
      ),
    );
  }
}
