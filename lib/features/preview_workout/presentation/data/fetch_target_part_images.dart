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

  // --- Maps and color converter (Unchanged) ---
  String colorToRgbString(Color color) =>
      '${color.red},${color.green},${color.blue}';
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

  // --- PRIVATE HELPER FUNCTIONS (Unchanged section) ---
  Future<Image> _fetchAndCacheImage({
    required List<String> mappedPrimary,
    required List<String> mappedSecondary,
    required bool transparent,
    String? cacheId,
  }) async {
    mappedSecondary.removeWhere((m) => mappedPrimary.contains(m));
    mappedPrimary.sort();
    mappedSecondary.sort();
    final idPart = cacheId ?? 'lists';
    String cacheKey =
        'muscle_image_${idPart}_${mappedPrimary.join("_")}_${mappedSecondary.join("_")}_transparent_${transparent ? 1 : 0}';
    // await cacheBox.clear();
    if (cacheBox.containsKey(cacheKey)) {
      final cachedBytes = cacheBox.get(cacheKey)!;
      return Image.memory(cachedBytes, fit: BoxFit.contain);
    }
    String primaryColor = colorToRgbString(
      const Color.fromARGB(255, 255, 111, 0),
    );
    String secondaryColor = colorToRgbString(
      const Color.fromARGB(255, 255, 213, 0),
    );
    final uri = Uri.parse(
      '${baseUrl}muscle-image?primary_muscles=${Uri.encodeComponent(mappedPrimary.join(","))}&secondary_muscles=${Uri.encodeComponent(mappedSecondary.join(","))}&primary_color=$primaryColor&secondary_color=$secondaryColor&transparent=${transparent ? 1 : 0}',
    );
    print(uri);
    final response = await http.get(
      uri,
      headers: {'User-Agent': 'Mozilla/5.0'},
    );
    if (response.statusCode == 200 &&
        response.headers['content-type']?.contains('image') == true) {
      final bytes = response.bodyBytes;
      await cacheBox.put(cacheKey, bytes);
      return Image.memory(bytes, fit: BoxFit.contain);
    } else {
      throw Exception(
        'Failed to fetch or process muscle image: ${response.statusCode}',
      );
    }
  }

  // --- NEW PRIVATE HELPER WIDGET ---
  /// Wraps an image in a GestureDetector to show it in a dialog on long press.
  Widget _buildInteractiveImagePopup(BuildContext context, Image image) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (ctx) => Dialog(
            backgroundColor: AppPalette.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.all(16),
            // InteractiveViewer allows pinch-to-zoom and panning.
            child: InteractiveViewer(
              child: image,
            ),
          ),
        );
      },
      child: image,
    );
  }

  // --- PUBLIC FUNCTIONS (Unchanged section) ---
  Future<Image> getMuscleImageForExercise(
    Exercise exercise, {
    bool transparent = false,
  }) async {
    final mappedPrimary = [
      targetMap[exercise.targetMuscle] ?? exercise.targetMuscle,
    ];
    final mappedSecondary = exercise.secondaryMuscles
        .map((m) => secondaryMap[m] ?? m)
        .toSet()
        .toList();
    return await _fetchAndCacheImage(
      mappedPrimary: mappedPrimary,
      mappedSecondary: mappedSecondary,
      transparent: transparent,
      cacheId: exercise.id,
    );
  }

  Future<Image> getMuscleImageForLists({
    required List<String> primaryMuscles,
    required List<String> secondaryMuscles,
    bool transparent = false,
  }) async {
    final mappedPrimary = primaryMuscles
        .map((m) => targetMap[m.toLowerCase()] ?? m)
        .toSet()
        .toList();
    final mappedSecondary = secondaryMuscles
        .map((m) => secondaryMap[m.toLowerCase()] ?? m)
        .toSet()
        .toList();
    return await _fetchAndCacheImage(
      mappedPrimary: mappedPrimary,
      mappedSecondary: mappedSecondary,
      transparent: transparent,
    );
  }

  // --- MODIFIED PUBLIC BUILDER WIDGETS ---

  /// Builds a styled container with a FutureBuilder for an Exercise object.
  /// On long press, the image is shown in a zoomable dialog.
  Widget getMuscleImageBuilderForExercise(
    Exercise exercise, {
    bool transparent = true,
    double height = 120,
    double width = 120,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPalette.outlineEnabled),
      ),
      width: height,
      height: width,
      child: FutureBuilder<Image>(
        future: getMuscleImageForExercise(exercise, transparent: transparent),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // MODIFIED: Use the helper to make the image interactive
            return _buildInteractiveImagePopup(context, snapshot.data!);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  /// Builds a styled container with a FutureBuilder for lists of muscle strings.
  /// On long press, the image is shown in a zoomable dialog.
  Widget getMuscleImageBuilderForLists({
    required List<String> primaryMuscles,
    required List<String> secondaryMuscles,
    bool transparent = true,
    double height = 120,
    double width = 120,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPalette.outlineEnabled),
      ),
      width: width,
      height: height,
      child: FutureBuilder<Image>(
        future: getMuscleImageForLists(
          primaryMuscles: primaryMuscles,
          secondaryMuscles: secondaryMuscles,
          transparent: transparent,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // MODIFIED: Use the helper to make the image interactive
            return _buildInteractiveImagePopup(context, snapshot.data!);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
