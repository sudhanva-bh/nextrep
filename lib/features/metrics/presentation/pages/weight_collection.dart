import 'package:flutter/material.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_with_push.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/auth/presentation/widgets/continue_button.dart';
import 'package:nextrep/features/metrics/presentation/pages/experience_collection.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/unit_switcher.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/weight_screen/kgs_weight_widget.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/weight_screen/lbs_weight_widget.dart';
import 'package:nextrep/core/services/user_profile/user_profile_service.dart';

enum Units {
  kg,
  lb,
}

class WeightCollection extends StatefulWidget {
  const WeightCollection({super.key});

  @override
  State<WeightCollection> createState() => _WeightCollectionState();
}

class _WeightCollectionState extends State<WeightCollection> {
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
    final cloudService = UserProfileService();
    await cloudService.updateWeight(weight);
    NavigateWithPush(context, ExperienceCollection());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isKg = units == Units.kg;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02), // Top spacing
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
                isCmSelected: isKg,
                unit1: 'kg',
                unit2: 'lb',
              ),
              SizedBox(height: screenHeight * 0.04),

              // Weight Scroll Selector Container
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
