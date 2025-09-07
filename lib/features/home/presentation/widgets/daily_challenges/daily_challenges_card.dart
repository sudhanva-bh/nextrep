import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/challenges/challenge.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/challenges/presentation/pages/challenges_page.dart';

class DailyChallengesCard extends StatelessWidget {
  const DailyChallengesCard({
    super.key,
    required this.challenge,
    required this.onProgressTap,
  });

  final Challenge challenge;
  final VoidCallback onProgressTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                ChallengeDetailsPage(challengeTitle: challenge.title),
          ),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 266,
        height: 180,
        decoration: BoxDecoration(
          boxShadow: WidgetProperties.dropShadow,
          color: AppPalette.surface,
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: AssetImage(challenge.imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(16),
                width: 180,
                child: Text(
                  challenge.title,
                  style: TextStyle(
                    color: AppPalette.onSecondary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.04,
                    shadows: [
                      Shadow(
                        offset: const Offset(2, 2),
                        blurRadius: 8,
                        color: AppPalette.shadow.withAlpha(155),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: InkWell(
                onTap: onProgressTap,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      width: 149,
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppPalette.surface.withAlpha(120),
                        boxShadow: WidgetProperties.dropShadow,
                        gradient: LinearGradient(
                          colors: [
                            AppPalette.primary,
                            AppPalette.primary,
                            AppPalette.surface.withAlpha(120),
                            AppPalette.surface.withAlpha(120),
                          ],
                          stops: [
                            0,
                            challenge.isCompleted
                                ? 1
                                : challenge.progress - 0.05,
                            challenge.progress,
                            1,
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Spacer(),
                          Text(
                            "${challenge.totalDays} Days",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppPalette.onSurface,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          challenge.isCompleted
                              ? const Icon(Icons.check_rounded)
                              : const Icon(Icons.arrow_forward_ios_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}