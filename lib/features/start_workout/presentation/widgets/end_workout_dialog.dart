import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

/// Represents the final choice a user makes in the end workout flow.
enum EndWorkoutResult {
  save,
  discard,
}

/// A helper class to display the end-of-workout confirmation dialogs.
class EndWorkoutDialog {
  /// Shows the dialog sequence and returns the user's choice.
  static Future<EndWorkoutResult?> show(
    BuildContext context, {
    // ✨ These lists are now required to show progress.
    required List<bool> workoutsDone,
    required List<List<bool>> setsDone,
  }) async {
    //
    // --- Calculate Progress Stats ---
    //
    final int completedWorkouts = workoutsDone.where((done) => done).length;
    final int totalWorkouts = workoutsDone.length;

    final int completedSets = setsDone.fold(
      0,
      (sum, setsInWorkout) => sum + setsInWorkout.where((done) => done).length,
    );
    final int totalSets = setsDone.fold(
      0,
      (sum, setsInWorkout) => sum + setsInWorkout.length,
    );

    //
    // DIALOG 1: Confirm ending the workout, now with progress stats.
    //
    final bool? didConfirmEnd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Workout?'),
        // ✨ The content is now a custom Column with the progress summary.
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Here is your progress so far:'),
            const SizedBox(height: 20),
            _ProgressStat(
              icon: Icons.check_circle_outline,
              label: 'Exercises Completed',
              completed: completedWorkouts,
              total: totalWorkouts,
              color: AppPalette.primary,
            ),
            const SizedBox(height: 12),
            _ProgressStat(
              icon: Icons.repeat,
              label: 'Total Sets Completed',
              completed: completedSets,
              total: totalSets,
              color: AppPalette.onSurface,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Continue Workout'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppPalette.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes, End'),
          ),
        ],
      ),
    );

    // If the user cancels the first dialog, stop the process.
    if (didConfirmEnd != true) {
      return null;
    }

    //
    // DIALOG 2: Ask if the user wants to save their changes (this remains unchanged).
    //
    final bool? didConfirmSave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Changes?'),
        content: const Text(
          'Do you want to save the changes made to this workout (e.g., modified sets, added/deleted exercises)?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Discard
            child: const Text('Discard'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Save
            child: const Text('Save'),
          ),
        ],
      ),
    );
        
    if (didConfirmSave == true) {
      return EndWorkoutResult.save;
    } else if (didConfirmSave == false) {
      return EndWorkoutResult.discard;
    }
    return null;
  }
}

/// A private helper widget to display a single row of progress statistics.
class _ProgressStat extends StatelessWidget {
  const _ProgressStat({
    required this.icon,
    required this.label,
    required this.completed,
    required this.total,
    required this.color,
  });

  final IconData icon;
  final String label;
  final int completed;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(label, style: textTheme.bodyMedium),
        const Spacer(),
        RichText(
          text: TextSpan(
            style: textTheme.bodyMedium?.copyWith(color: AppPalette.onSurface),
            children: [
              TextSpan(
                text: '$completed',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' / '),
              TextSpan(text: '$total'),
            ],
          ),
        )
      ],
    );
  }
}
