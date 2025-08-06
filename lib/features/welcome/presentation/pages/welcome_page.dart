import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/file_paths.dart';
import 'package:nextrep/core/navigation/navigate_to_classes/navigate_with_fade.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/auth/presentation/pages/auth_page.dart';
import 'package:nextrep/features/welcome/presentation/widgets/cut_out_text.dart';
import 'package:nextrep/features/welcome/presentation/widgets/non_cut_out_text.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int position = 0;
  List<String> attributes = [
    'Strength',
    'Discipline',
    'Endurance',
    'Agility',
    'Power',
    'Focus',
    'Drive',
    'Stamina',
    'Flexibility',
    'Grit',
    'Speed',
    'Control',
    'Determination',
    'Persistence',
    'Resilience',
    'Recovery',
    'Momentum',
    'Intensity',
    'Mastery',
    'Greatness',
  ];

  double continueTransitionScale = 0;
  int pageTransitionDuration = 1000;

  Future<void> transition() async {
    await Future.delayed(
      Duration(milliseconds: pageTransitionDuration),
      () {},
    );
    navigate();
  }

  void navigate() {
    NavigateWithFadeNoBack(context, AuthPage());
  }

  late Timer _timer;

  void animateAttributes() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        position = (position + 1) % attributes.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    animateAttributes();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String attribute = attributes[position];
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              FilePaths.welcomeImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppPalette.background,
                    AppPalette.transparent,
                    AppPalette.transparent,
                    AppPalette.background,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, .19, .65, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Flex(
                direction: Axis.vertical,
                children: [
                  const Expanded(
                    flex: 20,
                    child: SizedBox(),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CutOutText(
                            text: attribute,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          const NonCutOutText(text: "Lives"),
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NonCutOutText(text: "in the"),
                          SizedBox(
                            width: 3,
                          ),
                          CutOutText(
                            text: 'NextRep',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          continueTransitionScale = 25;
                        });
                        transition();
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedScale(
              scale: continueTransitionScale,
              // curve: Curves.easeIn,
              duration: Duration(milliseconds: pageTransitionDuration),
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppPalette.background,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
