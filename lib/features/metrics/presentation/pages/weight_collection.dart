import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/bottom_navigator_controller.dart';
import 'package:nextrep/core/common/providers.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_with_push.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/auth/presentation/widgets/continue_button.dart';
import 'package:nextrep/features/metrics/presentation/pages/experience_collection.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/unit_switcher.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/weight_screen/kgs_weight_widget.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/weight_screen/lbs_weight_widget.dart';

enum Units { kg, lb }

class WeightCollection extends ConsumerStatefulWidget {
  const WeightCollection({super.key});

  @override
  ConsumerState<WeightCollection> createState() => _WeightCollectionState();
}

class _WeightCollectionState extends ConsumerState<WeightCollection> {
  double weight = 81.0;

  int get weightToKg => weight.floor();
  int get weightToKgDecimal => ((weight - weight.floor()) * 10).round();
  int get weightToLb => (weight * 2.20462).floor();
  int get weightToLbDecimal => (((weight * 2.20462) - weightToLb) * 10).round();

  Units units = Units.kg;

  void changeToKg() => setState(() => units = Units.kg);
  void changeToLb() => setState(() => units = Units.lb);
  void setWeight(double inputWeight) => setState(() => weight = inputWeight);

  Future<void> continueToExperienceCollection() async {
    final cloudService = ref.read(userProfileServiceProvider);
    await cloudService.addWeightEntry(weight);
    NavigateWithPush(context, const ExperienceCollection());
  }

  void skipToHome(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Warning"),
        content: const Text(
          "Are you sure you want to skip? You may face errors if data has not been entered correctly.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              NavigateWithPush(context, const BottomNavigatorController());
            },
            child: const Text("Yes, Skip"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isKg = units == Units.kg;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => skipToHome(context),
        label: const Text("Skip"), // The text on the button
        icon: const Icon(Icons.arrow_forward), // Optional icon
      ),
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Enter your Weight",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.01),
              UnitSwitcher(
                onUnit1Pressed: changeToKg,
                onUnit2Pressed: changeToLb,
                isCmSelected:
                    isKg, // you might want to rename `isCmSelected` → `isUnit1Selected`
                unit1: 'kg',
                unit2: 'lb',
              ),
              SizedBox(height: screenHeight * 0.04),
              Container(
                height: screenHeight * 0.52,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: AppPalette.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: isKg
                      ? KgsWeightWidget(
                          key: const ValueKey('kg_widget'),
                          initialValueKg: weightToKg,
                          initialValueKgDecimal: weightToKgDecimal,
                          updateWeight: setWeight,
                        )
                      : LbsWeightWidget(
                          key: const ValueKey('lb_widget'),
                          initialValueLb: weightToLb,
                          initialValueLbDecimal: weightToLbDecimal,
                          updateWeight: setWeight,
                        ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              ContinueButton(
                text: "Continue",
                onPressed: continueToExperienceCollection,
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
