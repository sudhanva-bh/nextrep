import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nextrep/core/common/utils/bmi_calculator.dart';
import 'package:nextrep/core/entities/user/user_profile_model.dart';
import 'package:nextrep/core/services/user_profile/user_profile_service.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import '../widgets/bmi_chart_card.dart';
import '../widgets/bmi_ranges_card.dart';
import '../widgets/current_bmi_card.dart';
import '../widgets/empty_state_display.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final _userProfileService = UserProfileService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // FAB shown when a profile exists (even if weightHistory is empty)
      floatingActionButton: ValueListenableBuilder<UserProfile?>(
        valueListenable: _userProfileService.getProfileListenable(),
        builder: (context, profile, _) {
          if (profile == null) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            backgroundColor: AppPalette.primary,
            foregroundColor: AppPalette.onPrimary,
            icon: const Icon(Icons.add),
            label: const Text('Add weight'),
            onPressed: () => _openAddWeightDialog(context),
          );
        },
      ),
      body: ValueListenableBuilder<UserProfile?>(
        valueListenable: _userProfileService.getProfileListenable(),
        builder: (context, userProfile, _) {
          // No profile or invalid height -> prompt to set height
          if (userProfile == null || userProfile.height <= 0) {
            return const EmptyStateDisplay(
              message:
                  'Please set your height in your profile to calculate BMI.',
            );
          }

          // When no weight history, show empty state (user can still add weight via FAB)
          if (userProfile.weightHistory.isEmpty) {
            return const EmptyStateDisplay(
              message: 'Add your first weight entry to see your BMI chart.',
            );
          }

          // Otherwise render progress UI
          final latestWeight = userProfile.weightHistory.last.weight;
          final currentBmi = calculateBmi(latestWeight, userProfile.height);
          final bmiInfo = getBmiInfo(currentBmi);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverAppBar(
                pinned: true,
                backgroundColor: AppPalette.background,
                centerTitle: true,
                title: Text(
                  'BMI Progress',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      CurrentBmiCard(bmi: currentBmi, info: bmiInfo),
                      const SizedBox(height: 24),
                      BmiChartCard(profile: userProfile),
                      const SizedBox(height: 24),
                      const BmiRangesCard(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openAddWeightDialog(BuildContext context) async {
    // Create controller JUST BEFORE opening the dialog and do NOT dispose it here.
    final weightController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    final dateFormatter = DateFormat.yMMMd();

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: const Text('Add weight entry'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: weightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      hintText: 'e.g. 72.5',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Date: ${dateFormatter.format(selectedDate)}',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: selectedDate,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365 * 5),
                            ),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.primary,
                  ),
                  onPressed: () async {
                    final raw = weightController.text.trim();
                    if (raw.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a weight value.'),
                        ),
                      );
                      return;
                    }
                    final parsed = double.tryParse(raw.replaceAll(',', '.'));
                    if (parsed == null || parsed <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Enter a valid positive number for weight.',
                          ),
                        ),
                      );
                      return;
                    }

                    try {
                      // Add the entry
                      await _userProfileService.addWeightEntry(
                        parsed,
                        date: selectedDate,
                      );

                      // Sort if custom date
                      final now = DateTime.now();
                      final isSameDate =
                          now.year == selectedDate.year &&
                          now.month == selectedDate.month &&
                          now.day == selectedDate.day;

                      if (!isSameDate) {
                        await _userProfileService.sortWeightHistory();
                      }

                      // 🔥 Force ProgressPage to rebuild immediately
                      if (mounted) setState(() {});

                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Saved weight ${parsed.toStringAsFixed(1)} kg',
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save weight: $e')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
