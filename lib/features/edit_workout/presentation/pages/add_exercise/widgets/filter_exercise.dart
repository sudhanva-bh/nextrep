import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/core/common/providers.dart';
import 'package:nextrep/core/services/exercises/exercise_raw_data_service.dart';
import 'package:nextrep/core/theme/app_palette.dart';

// The StatefulWidget class, corrected to use the file's conventional name.
class FilterExercise extends ConsumerStatefulWidget {
  // Receives the currently active filters from the previous screen.
  final Map<String, Set<String>> initialFilters;

  const FilterExercise({
    super.key,
    required this.initialFilters,
  });

  @override
  ConsumerState<FilterExercise> createState() => _FilterExerciseState();
}

class _FilterExerciseState extends ConsumerState<FilterExercise> {
  late ExerciseService _exerciseService;

  // A temporary copy of the filters to be modified within this screen.
  late final Map<String, Set<String>> _tempFilters;

  // Pre-load all available filter options
  late final List<String> _allCategories;
  late final List<String> _allBodyParts;
  late final List<String> _allTargetMuscles;
  late final List<String> _allEquipment;

  // State for the ToggleButtons
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _exerciseService = ref.read(exerciseServiceProvider);
    _tempFilters = {
      'category': Set<String>.from(widget.initialFilters['category']!),
      'bodyPart': Set<String>.from(widget.initialFilters['bodyPart']!),
      'targetMuscle': Set<String>.from(widget.initialFilters['targetMuscle']!),
      'equipment': Set<String>.from(widget.initialFilters['equipment']!),
    };

    // Determine the initial state of the toggle button.
    if (_tempFilters['targetMuscle']!.isNotEmpty) {
      _selectedIndex = 1;
    } else {
      _selectedIndex = 0;
    }

    // Set the default filter if no category is selected yet.
    if (_tempFilters['category']!.isEmpty) {
      _tempFilters['category']!.add('strength');
    }

    // Load all filter options from the service.
    _allCategories = _exerciseService.getAllCategories();
    _allBodyParts = _exerciseService.getAllBodyParts();
    _allTargetMuscles = _exerciseService.getAllTargetMuscles();
    _allEquipment = _exerciseService.getAllEquipment();
  }

  /// Clears the inactive filter set and returns the results.
  void _applyFilters() {
    // If "Body Part" is selected, clear any "Target Muscle" selections.
    if (_selectedIndex == 0) {
      _tempFilters['targetMuscle']!.clear();
    }
    // If "Target Muscle" is selected, clear any "Body Part" selections.
    else {
      _tempFilters['bodyPart']!.clear();
    }
    // Return the cleaned-up filter map.
    Navigator.pop(context, _tempFilters);
  }

  /// A helper to build a single filter card.
  Widget _buildFilterCard({
    required String title,
    required List<String> options,
    required Set<String> selectedOptions,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: options.map((option) {
                // Using the lowercase version for comparison from the start.
                final isSelected = selectedOptions.contains(
                  option.toLowerCase(),
                );
                return FilterChip(
                  label: Text(
                    option,
                    style: TextStyle(
                      color: isSelected
                          ? AppPalette.primary
                          : AppPalette.onSurface,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      final lowercasedOption = option.toLowerCase();
                      if (selected) {
                        selectedOptions.add(lowercasedOption);
                      } else {
                        selectedOptions.remove(lowercasedOption);
                      }
                    });
                  },
                  backgroundColor: AppPalette.lightSurface,
                  selectedColor: AppPalette.primary.withAlpha(51),
                  checkmarkColor: AppPalette.primary,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: isSelected
                          ? AppPalette.primary
                          : AppPalette.outline,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context), // Pop without returning data
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                // Clear all selections and apply the default.
                _tempFilters.forEach((key, value) => value.clear());
                _tempFilters['category']!.add('strength');
              });
            },
            child: const Text('Clear'),
          ),
          // "Apply" button now calls the new method.
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilledButton(
              onPressed: _applyFilters,
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFilterCard(
            title: 'Category',
            options: _allCategories,
            selectedOptions: _tempFilters['category']!,
          ),
          Center(
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(24),
              borderColor: AppPalette.outline,
              selectedBorderColor: AppPalette.primary,
              fillColor: AppPalette.primary.withAlpha(51),
              selectedColor: AppPalette.primary,
              color: AppPalette.onSurface,
              constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
              isSelected: [_selectedIndex == 0, _selectedIndex == 1],
              onPressed: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Body Part"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Target Muscle"),
                ),
              ],
            ),
          ),
          _selectedIndex == 0
              ? _buildFilterCard(
                  title: 'Body Part',
                  options: _allBodyParts,
                  selectedOptions: _tempFilters['bodyPart']!,
                )
              : _buildFilterCard(
                  title: 'Target Muscle',
                  options: _allTargetMuscles,
                  selectedOptions: _tempFilters['targetMuscle']!,
                ),
          _buildFilterCard(
            title: 'Equipment',
            options: _allEquipment,
            selectedOptions: _tempFilters['equipment']!,
          ),
        ],
      ),
    );
  }
}
