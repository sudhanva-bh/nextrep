import 'package:flutter/material.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/features/preview_workout/presentation/widgets/popup_container.dart';

class BottomWorkoutPreviewPopup {
  final Exercise exercise;

  BottomWorkoutPreviewPopup({required this.exercise});

  void showPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true, // allows full screen height
      backgroundColor: Colors.transparent, // optional for rounded corners
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4, // initial height (40% of screen)
        minChildSize: 0.2, // minimum height
        maxChildSize: 1, // maximum height
        builder: (context, scrollController) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: PopupContainer(
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
