import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextrep/core/entities/challenges/challenge.dart';
import 'package:nextrep/core/services/challenges/challenges_service.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ChallengeDetailsPage extends StatefulWidget {
  final String challengeTitle;
  const ChallengeDetailsPage({super.key, required this.challengeTitle});

  @override
  State<ChallengeDetailsPage> createState() => _ChallengeDetailsPageState();
}

class _ChallengeDetailsPageState extends State<ChallengeDetailsPage> {
  final _challengesService = ChallengesService();

  void _onDayTapped(Challenge challenge, int dayIndex) {
    HapticFeedback.lightImpact();
    setState(() {
      challenge.toggleDay(dayIndex);
      _challengesService.updateChallenge(challenge);
    });
  }

  Future<void> _showResetConfirmationDialog(Challenge challenge) async {
    final bool? didConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Challenge?'),
        content: const Text(
          'This will reset all your progress for this challenge. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppPalette.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes, Reset'),
          ),
        ],
      ),
    );

    if (didConfirm == true) {
      setState(() {
        challenge.restartChallenge();
        _challengesService.updateChallenge(challenge);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _challengesService.challengeListenable(
        widget.challengeTitle,
      ),
      builder: (context, Challenge? challenge, child) {
        if (challenge == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                stretch: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Reset Progress',
                    onPressed: () => _showResetConfirmationDialog(challenge),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    challenge.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 4,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(challenge.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppPalette.background.withOpacity(0.7),
                            AppPalette.background,
                          ],
                          stops: const [0, 0.7, 1],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      _buildProgressIndicator(challenge),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        "Daily Progress",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: challenge.totalDays,
                  itemBuilder: (context, index) {
                    final isDone = challenge.dailyProgress[index];
                    return _DayCircle(
                      dayNumber: index + 1,
                      isDone: isDone,
                      onTap: () => _onDayTapped(challenge, index),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(Challenge challenge) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${challenge.daysDone} of ${challenge.totalDays} days completed',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        LinearPercentIndicator(
          percent: challenge.progress,
          lineHeight: 12,
          barRadius: const Radius.circular(6),
          backgroundColor: AppPalette.surface,
          progressColor: AppPalette.primary,
          animation: true,
        ),
      ],
    );
  }
}

class _DayCircle extends StatelessWidget {
  final int dayNumber;
  final bool isDone;
  final VoidCallback onTap;

  const _DayCircle({
    required this.dayNumber,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDone ? AppPalette.primary : AppPalette.surface,
          border: Border.all(
            color: isDone ? AppPalette.primary : AppPalette.outline,
            width: 2,
          ),
        ),
        child: Center(
          child: isDone
              ? const Icon(Icons.check, color: AppPalette.onPrimary, size: 24)
              : Text(
                  '$dayNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
