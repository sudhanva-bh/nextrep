import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/user/user_profile_model.dart';
import 'package:nextrep/core/services/user_profile/user_profile_service.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/home/presentation/widgets/bmi/bmi_slider.dart';
import 'package:nextrep/features/home/presentation/widgets/bmi/bmi_tile.dart';

class BmiCard extends StatefulWidget {
  const BmiCard({
    super.key,
    required this.userProfile,
    required this.userProfileService,
  });

  final UserProfile userProfile;
  final UserProfileService userProfileService;

  @override
  State<BmiCard> createState() => _BmiCardState();
}

class _BmiCardState extends State<BmiCard> {
  late double bmi;
  late double? targetBmi;
  late double height;
  late double weight;
  late double? target;

  void calculateBMI() {
    double heightM = height / 100;
    bmi = weight / (heightM * heightM);
    if (target != null) {
      targetBmi = target! / (heightM * heightM);
    } else {
      targetBmi = null;
    }
  }

  void calculateParameters() {
    height = widget.userProfile.height;
    weight = widget.userProfile.weight;
    target = widget.userProfile.targetWeight;
    calculateBMI();
  }

  @override
  void initState() {
    calculateParameters();
    super.initState();
  }

  Future<void> onSubmit(String parameterName, double newParameter) async {
    switch (parameterName) {
      case 'Height':
        await widget.userProfileService.updateHeight(newParameter);
        setState(() => height = newParameter);
        break;
      case 'Weight':
        await widget.userProfileService.updateWeight(newParameter);
        setState(() => weight = newParameter);
        break;
      case 'Target':
        await widget.userProfileService.updateTargetWeight(newParameter);
        setState(() => target = newParameter);
        break;
    }
    setState(() {
      calculateBMI();
    });
  }

  Future<void> showInputDialog({
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
            hintText = "in KGs";
            break;
          case 'Target':
            hintText = "in KGs";
            break;
        }
        return AlertDialog(
          title: Text("Enter $parameterName"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 210,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: WidgetProperties.dropShadow,
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Body Mass Index (BMI)",
            style: TextStyle(
              color: AppPalette.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.6,
            ),
          ),
          SizedBox(height: 5),
          Text(
            bmi.toStringAsFixed(1),
            style: TextStyle(
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
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 64,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppPalette.lightSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => showInputDialog(
                    context: context,
                    onSubmit: (inputText) {
                      final parsed = double.tryParse(inputText);
                      if (parsed != null) {
                        onSubmit('Height', parsed);
                      }
                    },
                    parameterName: 'Height',
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: BmiTile(
                    parameterName: 'Height',
                    parameter: height,
                    icon: Icons.height,
                  ),
                ),
                VerticalDivider(color: AppPalette.onSurface.withAlpha(190)),
                InkWell(
                  onTap: () => showInputDialog(
                    context: context,
                    onSubmit: (inputText) {
                      final parsed = double.tryParse(inputText);
                      if (parsed != null) {
                        onSubmit('Weight', parsed);
                      }
                    },
                    parameterName: 'Weight',
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: BmiTile(
                    parameterName: 'Weight',
                    parameter: weight,
                    icon: Icons.monitor_weight_outlined,
                  ),
                ),
                VerticalDivider(color: AppPalette.onSurface.withAlpha(190)),
                InkWell(
                  onTap: () => showInputDialog(
                    context: context,
                    onSubmit: (inputText) {
                      final parsed = double.tryParse(inputText);
                      if (parsed != null) {
                        onSubmit('Target', parsed);
                      }
                    },
                    parameterName: 'Target',
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: BmiTile(
                    parameterName: 'Target',
                    parameter: target,
                    icon: Icons.adjust,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
