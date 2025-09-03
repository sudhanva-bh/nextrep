import 'package:flutter/material.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/preview_workout/presentation/widgets/preview_popup_container.dart';

class BottomWorkoutPreviewPopup {
  static void showPopup(BuildContext context, Exercise exercise) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: AppPalette.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 1,
        builder: (context, scrollController) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: PreviewPopupContainer(
                exercise: exercise,
                scrollController: scrollController,
              ),
            ),
          );
        },
      ),
    );
  }
}
