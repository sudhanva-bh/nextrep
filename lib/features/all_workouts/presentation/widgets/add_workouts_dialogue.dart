import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nextrep/core/common/utils/show_snackbar.dart';
import 'package:nextrep/core/constants/file_paths.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class AddWorkoutDialog extends StatefulWidget {
  const AddWorkoutDialog({super.key});

  @override
  State<AddWorkoutDialog> createState() => AddWorkoutDialogState();
}

class AddWorkoutDialogState extends State<AddWorkoutDialog> {
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
