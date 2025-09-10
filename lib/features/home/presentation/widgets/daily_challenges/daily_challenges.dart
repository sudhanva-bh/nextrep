import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/core/common/providers.dart';
import 'package:nextrep/core/entities/challenges/challenge.dart';
import 'package:nextrep/core/services/challenges/challenges_service.dart';
import 'package:nextrep/features/home/presentation/widgets/daily_challenges/daily_challenges_card.dart';

class DailyChallenges extends ConsumerStatefulWidget {
  const DailyChallenges({super.key});

  @override
  ConsumerState<DailyChallenges> createState() => _DailyChallengesState();
}

class _DailyChallengesState extends ConsumerState<DailyChallenges> {
  late ChallengesService _challengesService;

  @override
  void initState() {
    _challengesService = ref.read(challengesServiceProvider);
    super.initState();
  }

  void _handleChallengeTap(Challenge challenge) {
    if (challenge.isCompleted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Restart Challenge?'),
          content: Text(
            'You have already completed the "${challenge.title}" challenge. Would you like to restart it from Day 1?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                challenge.restartChallenge();
                _challengesService.updateChallenge(challenge);
                Navigator.of(context).pop();
              },
              child: const Text('Restart'),
            ),
          ],
        ),
      );
    } else {
      // ✨ FIX: Replace the incorrect method call with the new logic.
      // Find the index of the first incomplete day (the first 'false' value).
      final nextDayIndex = challenge.dailyProgress.indexOf(false);

      // If an incomplete day is found, toggle it to complete.
      if (nextDayIndex != -1) {
        challenge.toggleDay(nextDayIndex);
        _challengesService.updateChallenge(challenge);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Challenge>>(
      valueListenable: _challengesService.allChallengesListenable(),
      builder: (context, challenges, child) {
        if (challenges.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Daily Challenges",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(
                  challenges.length,
                  (index) {
                    final challenge = challenges[index];
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
                        challenge: challenge,
                        onProgressTap: () => _handleChallengeTap(challenge),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        );
      },
    );
  }
}
