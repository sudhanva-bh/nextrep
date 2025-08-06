import 'package:flutter/material.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_with_push.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/auth/presentation/widgets/continue_button.dart';
import 'package:nextrep/features/metrics/presentation/pages/weight_collection.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/height_screen/cm_height_widget.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/height_screen/inches_height_widget.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/unit_switcher.dart';
import 'package:nextrep/core/services/user_profile/user_profile_service.dart';

enum Units {
  cm,
  inch,
}

class HeightCollection extends StatefulWidget {
  const HeightCollection({super.key});

  @override
  State<HeightCollection> createState() => _HeightCollectionState();
}

class _HeightCollectionState extends State<HeightCollection> {
  double height = 171.0;

  int get heightToCm => height.floor();
  int get heightToCmDecimal => ((height - height.floor()) * 10).round();
  int get heightToFeet => (height / 30.48).floor();
  int get heightToInches => ((height / 2.54) - (heightToFeet * 12)).round();

  Units units = Units.cm;

  void changeToCM() => setState(() => units = Units.cm);
  void changeToInches() => setState(() => units = Units.inch);
  void setHeight(double inputHeight) => setState(() => height = inputHeight);

  Future<void> continueToWeightCollection() async {
    final cloudService = UserProfileService();
    await cloudService.updateHeight(height);
    NavigateWithPush(context, WeightCollection());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCm = units == Units.cm;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02), // 2% top padding
              Text(
                "Enter your Height",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.01),
              UnitSwitcher(
                onUnit1Pressed: changeToCM,
                onUnit2Pressed: changeToInches,
                isCmSelected: isCm,
                unit1: 'cm',
                unit2: 'in',
              ),
              SizedBox(height: screenHeight * 0.04),

              // Height Picker Container
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
                  child: isCm
                      ? CmHeightWidget(
                          key: const ValueKey('cm_widget'),
                          initialValueCm: heightToCm,
                          initialValueCmDecimal: heightToCmDecimal,
                          updateHeight: setHeight,
                        )
                      : InchesHeightWidget(
                          key: const ValueKey('inch_widget'),
                          initialValueFeet: heightToFeet,
                          initialValueInches: heightToInches,
                          updateHeight: setHeight,
                        ),
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              ContinueButton(
                text: "Continue",
                onPressed: continueToWeightCollection,
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
