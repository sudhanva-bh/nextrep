import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/services/exercises/exercise_raw_data_service.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/features/edit_workout/presentation/pages/add_exercise/widgets/filter_exercise.dart';
import 'package:nextrep/features/edit_workout/presentation/pages/add_exercise/widgets/search_exercise_tile.dart';

class AddExercisePopupContainer extends StatefulWidget {
  const AddExercisePopupContainer({
    super.key,
    required this.scrollController,
    required this.onAdd,
  });

  final ScrollController scrollController;
  final Function(String exerciseId) onAdd;

  @override
  State<AddExercisePopupContainer> createState() =>
      _AddExercisePopupContainerState();
}

class _AddExercisePopupContainerState extends State<AddExercisePopupContainer> {
  final _exerciseService = ExerciseService();
  late final TextEditingController _searchController;

  List<Exercise> _allExercises = [];
  List<Exercise> _filteredExercises = [];

  // State to hold active filters, now including targetMuscle
  final Map<String, Set<String>> _activeFilters = {
    'category': {'strength'}, // Set default filter
    'bodyPart': <String>{},
    'targetMuscle': <String>{},
    'equipment': <String>{},
  };

  int get _activeFilterCount =>
      _activeFilters.values.fold(0, (sum, set) => sum + set.length);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_filterExercises);
    _allExercises = _exerciseService.getAllExercises();
    _filterExercises(); // Run once initially to apply the default filter
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterExercises);
    _searchController.dispose();
    super.dispose();
  }

  void _filterExercises() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      List<Exercise> results = _allExercises;

      if (query.isNotEmpty) {
        results = results
            .where((e) => e.name.toLowerCase().contains(query))
            .toList();
      }

      final selectedCategories = _activeFilters['category']!;
      if (selectedCategories.isNotEmpty) {
        results = results
            .where((e) => selectedCategories.contains(e.category.toLowerCase()))
            .toList();
      }

      final selectedBodyParts = _activeFilters['bodyPart']!;
      if (selectedBodyParts.isNotEmpty) {
        results = results
            .where((e) => selectedBodyParts.contains(e.bodyPart.toLowerCase()))
            .toList();
      }

      final selectedTargetMuscles = _activeFilters['targetMuscle']!;
      if (selectedTargetMuscles.isNotEmpty) {
        results = results
            .where(
              (e) =>
                  selectedTargetMuscles.contains(e.targetMuscle.toLowerCase()),
            )
            .toList();
      }

      final selectedEquipment = _activeFilters['equipment']!;
      if (selectedEquipment.isNotEmpty) {
        results = results
            .where((e) => selectedEquipment.contains(e.equipment.toLowerCase()))
            .toList();
      }

      _filteredExercises = results;
    });
  }

  // Handles navigation to the new filter screen
  Future<void> _openFilterScreen() async {
    // Navigate and wait for the new screen to pop with data
    final result = await showDialog<Map<String, Set<String>>>(
      context: context,
      builder: (context) {
        // Wrap the FilterScreen in a Dialog widget for a popup container effect
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
            // Constrain the size of the dialog
            height: MediaQuery.of(context).size.height * 0.75,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FilterExercise(initialFilters: _activeFilters),
            ),
          ),
        );
      },
    );

    // If the user applied new filters, update the state and re-filter
    if (result != null) {
      setState(() {
        _activeFilters['category'] = result['category']!;
        _activeFilters['bodyPart'] = result['bodyPart']!;
        _activeFilters['targetMuscle'] = result['targetMuscle']!;
        _activeFilters['equipment'] = result['equipment']!;
      });
      _filterExercises();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: WidgetProperties.dropShadow,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 26),
                    color: AppPalette.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search exercises...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.withAlpha(25),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Badge(
                  label: Text(_activeFilterCount.toString()),
                  isLabelVisible: _activeFilterCount > 0,
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed:
                        _openFilterScreen, // Call the new navigation method
                    tooltip: 'Filter exercises',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _filteredExercises.isEmpty
                ? const Center(child: Text('No exercises found.'))
                : ListView.builder(
                    controller: widget.scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: _filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = _filteredExercises[index];
                      return SearchExerciseTile(
                        exercise: exercise,
                        onAdd: () => widget.onAdd(exercise.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
