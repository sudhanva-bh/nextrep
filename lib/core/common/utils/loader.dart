import 'package:flutter/material.dart';
import 'package:nextrep/core/constants/file_paths.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  FilePaths.loadingGif,
                  fit: BoxFit.contain,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        AppPalette.background.withAlpha(150),
                        AppPalette.transparent,
                      ],
                      stops: [0, 0.4],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              "Hang on!",
              style: TextStyle(
                fontSize: 36,
              ),
            ),
            Text(
              "Loading awesomeness",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
