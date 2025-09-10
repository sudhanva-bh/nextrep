import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/core/common/providers.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/user/user_profile_model.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/home/presentation/widgets/bmi/bmi_slider.dart';
import 'package:nextrep/features/home/presentation/widgets/bmi/bmi_tile.dart';

// Convert to a ConsumerWidget to access providers
class BmiCard extends ConsumerWidget {
  const BmiCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the UserProfileService from the provider
    final userProfileService = ref.watch(userProfileServiceProvider);

    // Use ValueListenableBuilder to listen for changes in the user profile
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: userProfileService.getProfileListenable(),
      builder: (context, userProfile, _) {
        // If profile doesn't exist, show an empty container or a loading state
        if (userProfile == null) {
          return const SizedBox(
            height: 210,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // --- All calculations are now done directly inside the builder ---
        final height = userProfile.height;
        final weight = userProfile.weightHistory.isNotEmpty
            ? userProfile.weightHistory.last.weight
            : 0.0;
        final target = userProfile.targetWeight;

        double bmi = 0;
        double? targetBmi;

        if (height > 0 && weight > 0) {
          final heightM = height / 100;
          final calculatedBmi = weight / (heightM * heightM);
          if (calculatedBmi.isFinite) {
            bmi = calculatedBmi;
          }

          if (target != null && target > 0) {
            final calculatedTargetBmi = target / (heightM * heightM);
            if (calculatedTargetBmi.isFinite) {
              targetBmi = calculatedTargetBmi;
            }
          }
        }

        // The UI structure remains the same
        return Container(
          width: double.infinity,
          height: 210,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            boxShadow: WidgetProperties.dropShadow,
            color: AppPalette.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Body Mass Index (BMI)",
                style: TextStyle(
                  color: AppPalette.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                bmi.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppPalette.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  letterSpacing: 0.6,
                  height: 1.16,
                ),
              ),
              BmiSlider(
                bmi: bmi,
                targetBmi: targetBmi,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 64,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppPalette.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildBmiInputTile(
                      context: context,
                      parameterName: 'Height',
                      parameterValue: height,
                      icon: Icons.height,
                      onSubmit: (value) =>
                          userProfileService.updateHeight(value),
                    ),
                    VerticalDivider(color: AppPalette.onSurface.withAlpha(190)),
                    _buildBmiInputTile(
                      context: context,
                      parameterName: 'Weight',
                      parameterValue: weight,
                      icon: Icons.monitor_weight_outlined,
                      onSubmit: (value) =>
                          userProfileService.addWeightEntry(value),
                    ),
                    VerticalDivider(color: AppPalette.onSurface.withAlpha(190)),
                    _buildBmiInputTile(
                      context: context,
                      parameterName: 'Target',
                      parameterValue: target,
                      icon: Icons.adjust,
                      onSubmit: (value) =>
                          userProfileService.updateTargetWeight(value),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper widget to reduce code duplication for the input tiles
  Widget _buildBmiInputTile({
    required BuildContext context,
    required String parameterName,
    required double? parameterValue,
    required IconData icon,
    required Future<void> Function(double) onSubmit,
  }) {
    return InkWell(
      onTap: () => _showInputDialog(
        context: context,
        parameterName: parameterName,
        onSubmit: (inputText) {
          final parsed = double.tryParse(inputText);
          if (parsed != null) {
            onSubmit(parsed);
          }
        },
      ),
      borderRadius: BorderRadius.circular(12),
      child: BmiTile(
        parameterName: parameterName,
        parameter: parameterValue,
        icon: icon,
      ),
    );
  }

  // Helper method for the dialog (can be kept outside the build method)
  Future<void> _showInputDialog({
    required BuildContext context,
    required void Function(String) onSubmit,
    required String parameterName,
  }) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        String hintText = "";
        switch (parameterName) {
          case 'Height':
            hintText = "in CM";
            break;
          case 'Weight':
          case 'Target':
            hintText = "in KGs";
            break;
        }
        return AlertDialog(
          title: Text("Enter $parameterName"),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
            ],
            autofocus: true,
            decoration: InputDecoration(
              hintText: hintText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final input = controller.text.trim();
                if (input.isNotEmpty) {
                  onSubmit(input);
                }
                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}
