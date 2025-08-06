import 'package:flutter/material.dart';
import 'package:nextrep/core/entities/challenges/preset_challenges.dart';
import 'package:nextrep/features/home/presentation/widgets/daily_challenges/daily_challenges_card.dart';

class DailyChallenges extends StatelessWidget {
  const DailyChallenges({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Daily Challenges",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: List.generate(
              presetChallenges.length,
              (index) {
                double leftPadding = index == 0 ? 24 : 0;
                double rightPadding = index == (presetChallenges.length - 1)
                    ? 24
                    : 14;
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    leftPadding,
                    12,
                    rightPadding,
                    12,
                  ),
                  child: DailyChallengesCard(
                    challenge: presetChallenges[index],
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
