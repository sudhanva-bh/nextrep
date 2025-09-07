import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/preview_workout/presentation/data/fetch_target_part_images.dart';
import 'package:nextrep/features/preview_workout/presentation/utils/consequtive_images.dart';
import 'package:nextrep/features/preview_workout/presentation/utils/info_tooltip.dart';
import 'package:nextrep/features/preview_workout/presentation/utils/numbered_list.dart';
import 'package:nextrep/features/preview_workout/presentation/utils/youtube_embed.dart';
import 'package:nextrep/features/preview_workout/presentation/widgets/target_muscle_chip.dart';

class PreviewPopupContainer extends StatelessWidget {
  const PreviewPopupContainer({
    super.key,
    required this.exercise,
    required this.scrollController,
  });

  final Exercise exercise;
  final ScrollController scrollController;

  String _capitalizeWords(String text) {
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: WidgetProperties.dropShadow,
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Drag handle
          Stack(
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Close button aligned right
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 26),
                  splashRadius: 22,
                  color: AppPalette.onSurface,
                ),
              ),
            ],
          ),

          // Exercise images
          ConsecutiveImages(
            firstImagePath: exercise.image0,
            secondImagePath: exercise.image1,
            aspectRatio: 1,
          ),
          const SizedBox(height: 20),

          // Exercise name
          Center(
            child: Text(
              exercise.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Center(
            child: Text(
              "${_capitalizeWords(exercise.bodyPart)} | ${_capitalizeWords(exercise.equipment)}",
              style: TextStyle(
                fontSize: 16,
                color: AppPalette.onSurface.withAlpha(190),
              ),
            ),
          ),

          SizedBox(height: 6),

          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 4, // horizontal space
                runSpacing: 6, // vertical space if they wrap
                children: [
                  TargetMuscleChip(
                    label: exercise.targetMuscle,
                    isPrimary: true,
                  ),
                  ...exercise.secondaryMuscles.map(
                    (muscle) => TargetMuscleChip(
                      label: muscle,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 12),

          Divider(
            thickness: 2,
          ),

          SizedBox(height: 12),
          Text(
            "DESCRIPTION",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Constrain width + height for scrollable text
              Expanded(
                child: SizedBox(
                  height: 120, // max visible height
                  child: Scrollbar(
                    trackVisibility: true,
                    thumbVisibility: true,
                    thickness: 6,
                    radius: const Radius.circular(12),
                    interactive: true,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          exercise.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppPalette.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12), // spacing between text & image
              // Fixed-size image
              SizedBox(
                height: 120,
                child: MuscleApiService().getMuscleImageBuilderForExercise(exercise),
              ),
            ],
          ),

          SizedBox(height: 12),
          Divider(
            thickness: 2,
          ),
          SizedBox(height: 12),

          Text(
            "INSTRUCTIONS",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 4),

          NumberedList(items: exercise.instructions),

          SizedBox(height: 12),
          Divider(
            thickness: 2,
          ),
          SizedBox(height: 12),

          Row(
            children: [
              Text(
                "VIDEO TUTORIAL",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              const InfoTooltip(
                message: "External videos may not always be accurate.",
              ),
            ],
          ),

          SizedBox(height: 8),

          YouTubeEmbed(exercise: exercise),
        ],
      ),
    );
  }
}
