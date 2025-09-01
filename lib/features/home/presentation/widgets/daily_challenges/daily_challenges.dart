import 'package:flutter/material.dart';
import 'package:nextrep/core/services/challenges/challenges_service.dart';
import 'package:nextrep/features/home/presentation/widgets/daily_challenges/daily_challenges_card.dart';

class DailyChallenges extends StatelessWidget {
  const DailyChallenges({super.key});

  @override
  Widget build(BuildContext context) {
    final challenges = ChallengesService().getAllChallenges();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
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
              challenges.length,
              (index) {
                double leftPadding = index == 0 ? 24 : 0;
                double rightPadding = index == (challenges.length - 1)
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
                    challenge: challenges[index],
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
