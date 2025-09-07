import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/preview_workout/presentation/data/fetch_target_part_images.dart';

class Overview extends StatelessWidget {
  const Overview({
    super.key,
    required this.length,
    required this.volume,
    required this.workoutsNames,
    required this.primaryMuscleGroups, required this.secondaryMuscleGroups,
  });

  final int length;
  final String workoutsNames, volume;
  final List<String> primaryMuscleGroups, secondaryMuscleGroups;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 146,
      decoration: BoxDecoration(
        color: AppPalette.surface,
        boxShadow: WidgetProperties.dropShadow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            MuscleApiService().getMuscleImageBuilderForLists(
              primaryMuscles: primaryMuscleGroups,
              secondaryMuscles: secondaryMuscleGroups,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$length Workouts",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.onSurface,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                    width: 82,
                    child: Divider(
                      color: AppPalette.lighterSurface,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    workoutsNames,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppPalette.lighterSurface,
                      height: 1.14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Targeted Muscles",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppPalette.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                    width: 125,
                    child: Divider(
                      color: AppPalette.lighterSurface,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    primaryMuscleGroups.join(", "),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppPalette.lighterSurface,
                      height: 1.14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Volume",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppPalette.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                    width: 125,
                    child: Divider(
                      color: AppPalette.lighterSurface,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "$volume kg",
                    style: TextStyle(
                      fontSize: 11,
                      color: AppPalette.lighterSurface,
                      height: 1.12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
