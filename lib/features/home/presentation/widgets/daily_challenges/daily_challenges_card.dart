import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/challenges/challenge.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class DailyChallengesCard extends StatelessWidget {
  const DailyChallengesCard({
    super.key,
    required this.challenge,
  });
  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 266,
      height: 180,
      decoration: BoxDecoration(
        boxShadow: WidgetProperties.dropShadow,
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: AssetImage(challenge.imagePath),
          fit: BoxFit.cover, // Optional: Ensures image covers the container
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(16),
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
                      offset: Offset(2, 2),
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
                        challenge.isCompleted ? 1 : challenge.progress - 0.05,
                        challenge.progress,
                        1,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Spacer(),
                      Text(
                        "${challenge.totalDays} Days",
                        style: TextStyle(
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
                      Spacer(),
                      challenge.isCompleted
                          ? Icon(Icons.check_rounded)
                          : Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
