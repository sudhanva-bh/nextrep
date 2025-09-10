import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/bottom_navigator_controller.dart';
import 'package:nextrep/core/common/providers.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_with_push.dart';
import 'package:nextrep/features/auth/presentation/widgets/continue_button.dart';
import 'package:nextrep/features/metrics/presentation/pages/height_collection.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/gender_screen/gender_tile.dart';

class GenderCollection extends ConsumerStatefulWidget {
  const GenderCollection({super.key});

  @override
  ConsumerState<GenderCollection> createState() => _GenderCollectionState();
}

class _GenderCollectionState extends ConsumerState<GenderCollection> {
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
    final service = ref.read(userProfileServiceProvider);
    await service.updateGender(selectedGender!.name);
    NavigateWithPush(context, const HeightCollection());
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
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => skipToHome(context),
        label: const Text("Skip"),
        icon: const Icon(Icons.arrow_forward),
      ),
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 64),
            GenderTile(
              enabled: selectedGender == Gender.male,
              gender: Gender.male,
              onPressed: () => changeGender(Gender.male),
            ),
            const SizedBox(height: 12),
            GenderTile(
              enabled: selectedGender == Gender.female,
              gender: Gender.female,
              onPressed: () => changeGender(Gender.female),
            ),
            const SizedBox(height: 12),
            GenderTile(
              enabled: selectedGender == Gender.nonBinary,
              gender: Gender.nonBinary,
              onPressed: () => changeGender(Gender.nonBinary),
            ),
            const SizedBox(height: 24),
            AnimatedOpacity(
              opacity: selectedGender != null ? 1 : 0,
              duration: const Duration(milliseconds: 100),
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
