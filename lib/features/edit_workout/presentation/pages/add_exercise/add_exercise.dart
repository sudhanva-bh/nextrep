import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/edit_workout/presentation/pages/add_exercise/widgets/add_exercise_popup_container.dart';

class BottomAddExercisePopup {
  static void showPopup(
    BuildContext context,
    Function(String workoutId) onAdd,
  ) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: AppPalette.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.6,
        maxChildSize: 1,
        builder: (context, scrollController) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: AddExercisePopupContainer(
                scrollController: scrollController,
                onAdd: onAdd,
              ),
            ),
          );
        },
      ),
    );
  }
}
