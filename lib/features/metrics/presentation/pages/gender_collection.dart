import 'package:flutter/material.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_with_push.dart';
import 'package:nextrep/features/auth/presentation/widgets/continue_button.dart';
import 'package:nextrep/features/metrics/presentation/pages/height_collection.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/gender_screen/gender_tile.dart';
import 'package:nextrep/core/services/user_profile/user_profile_service.dart';

class GenderCollection extends StatefulWidget {
  const GenderCollection({super.key});

  @override
  State<GenderCollection> createState() => _GenderCollectionState();
}

class _GenderCollectionState extends State<GenderCollection> {
  Gender? selectedGender;

  void changeGender(Gender gender) {
    setState(() {
      if (selectedGender == gender) {
        selectedGender = null;
      } else {
        selectedGender = gender;
      }
    });
  }

  Future<void> continueToHeightCollection() async {
    final cloudService = UserProfileService();
    await cloudService.updateGender(selectedGender!.name);
    NavigateWithPush(context, HeightCollection());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 64),
            GenderTile(
              enabled: selectedGender == Gender.male,
              gender: Gender.male,
              onPressed: () => changeGender(Gender.male),
            ),
            SizedBox(height: 12),
            GenderTile(
              enabled: selectedGender == Gender.female,
              gender: Gender.female,
              onPressed: () => changeGender(Gender.female),
            ),
            SizedBox(height: 12),
            GenderTile(
              enabled: selectedGender == Gender.nonBinary,
              gender: Gender.nonBinary,
              onPressed: () => changeGender(Gender.nonBinary),
            ),
            SizedBox(height: 24),
            AnimatedOpacity(
              opacity: selectedGender != null ? 1 : 0,
              duration: Duration(milliseconds: 100),
              child: ContinueButton(
                text: "Continue",
                onPressed: continueToHeightCollection,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
