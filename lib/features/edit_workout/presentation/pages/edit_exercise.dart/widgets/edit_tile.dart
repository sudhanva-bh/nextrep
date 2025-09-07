import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/entities/workout/exercise_session.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_run_function.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/edit_workout/presentation/pages/edit_exercise.dart/widgets/sets_edit_tile.dart';
import 'package:nextrep/features/preview_workout/presentation/utils/bottom_workout_preview_popup.dart';

class EditTile extends StatefulWidget {
  const EditTile({
    super.key,
    required this.exerciseSession,
    required this.exercise,
    required this.index,
    required this.onUpdate,
    required this.onDeleteSet,
    required this.onAdd,
    required this.setStateFunction,
  });

  final ExerciseSession exerciseSession;
  final Exercise exercise;
  final int index;
  final Function(int setIndex, int reps, double weight) onUpdate;
  final Function(int setIndex) onDeleteSet;
  final Function setStateFunction;
  final Function onAdd;

  @override
  State<EditTile> createState() => _EditTileState();
}

class _EditTileState extends State<EditTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    widget.setStateFunction();
    if (_controller.isCompleted) {
      FocusScope.of(context).unfocus();
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(widget.exercise.id),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: WidgetProperties.dropShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ReorderableDragStartListener(
                  index: widget.index,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.drag_handle),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: NavigateRunFunction(
                    onTap: () => BottomWorkoutPreviewPopup.showPopup(
                      context,
                      widget.exercise,
                    ),
                    child: Image.asset(
                      widget.exercise.image0,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.exercise.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "ID: ${widget.exercise.id}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                  child: GestureDetector(
                    onTap: _toggleExpansion,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppPalette.lightSurface,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizeTransition(
            sizeFactor: _animation,
            axisAlignment: -1.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.exerciseSession.sets.length,
                    itemBuilder: (context, index) {
                      return SetsEditTile(
                        exerciseSet: widget.exerciseSession.sets[index],
                        onUpdate: (reps, weight) =>
                            widget.onUpdate(index, reps, weight),
                        onDelete: () => widget.onDeleteSet(index),
                      );
                    },
                  ),
                  SizedBox(height: 4),
                  TextButton(
                    onPressed: () => widget.onAdd(),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "+ Add Set",
                        style: TextStyle(
                          color: AppPalette.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
