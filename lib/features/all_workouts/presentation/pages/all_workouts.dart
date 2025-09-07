import 'package:flutter/material.dart';
import 'package:nextrep/core/common/utils/show_snackbar.dart';
import 'package:nextrep/core/constants/file_paths.dart';
import 'package:nextrep/core/entities/workout/workout.dart';
import 'package:nextrep/core/services/exercises/workouts_service.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/edit_workout/presentation/pages/edit_exercise.dart/edit_workout.dart';
import 'package:nextrep/features/home/presentation/widgets/favourite_workouts/favourite_workouts_tiles.dart';

class AllWorkouts extends StatelessWidget {
  const AllWorkouts({super.key});

  void _showAddWorkoutDialog(BuildContext context) async {
    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (context) => const _AddWorkoutDialog(),
    );

    if (result != null) {
      final workoutName = result['name'];
      final imagePath = result['imagePath'];

      if (workoutName != null && imagePath != null) {
        final newWorkout = Workout(
          workoutName: workoutName,
          imagePath: imagePath,
          exercises: [],
        );

        await WorkoutsService().uploadNewWorkout(newWorkout);

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditWorkout(
                workout: newWorkout,
                exercises: const [],
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Workouts",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<Workout>>(
        valueListenable: WorkoutsService().getAllWorkoutsListenable(),
        builder: (context, workouts, _) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (workouts.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 48.0),
                          child: Text('No workouts created yet.'),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: workouts.length,
                        itemBuilder: (context, index) {
                          return FavouriteWorkoutsTiles(
                            workout: workouts[index],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                      ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton.icon(
                        icon: const Icon(Icons.add),
                        onPressed: () => _showAddWorkoutDialog(context),
                        label: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Add Workout",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A private StatefulWidget to manage the state within the dialog.
class _AddWorkoutDialog extends StatefulWidget {
  const _AddWorkoutDialog();

  @override
  State<_AddWorkoutDialog> createState() => _AddWorkoutDialogState();
}

class _AddWorkoutDialogState extends State<_AddWorkoutDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedImagePath;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createWorkout() {
    if (_formKey.currentState!.validate() && _selectedImagePath != null) {
      Navigator.of(context).pop({
        'name': _nameController.text,
        'imagePath': _selectedImagePath,
      });
    } else if (_selectedImagePath == null) {
      showSnackBar(context, 'Please select an image for the workout.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Workout'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Workout Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose an Image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                width: 300,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: WorkoutImagePaths.allPaths.length,
                  itemBuilder: (context, index) {
                    final path = WorkoutImagePaths.allPaths[index];
                    final isSelected = path == _selectedImagePath;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedImagePath = path),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: AppPalette.primary, width: 3)
                              : Border.all(color: Colors.transparent, width: 3),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(path, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createWorkout,
          child: const Text('Create'),
        ),
      ],
    );
  }
}
