import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class ConsecutiveImages extends StatefulWidget {
  final String firstImagePath;
  final String secondImagePath;
  final double aspectRatio; // e.g. 1.5 means width:height = 3:2

  const ConsecutiveImages({
    super.key,
    required this.firstImagePath,
    required this.secondImagePath,
    this.aspectRatio = 1.0, // default square
  });

  @override
  State<ConsecutiveImages> createState() => _ConsecutiveImagesState();
}

class _ConsecutiveImagesState extends State<ConsecutiveImages> {
  bool showFirst = true;

  void _toggleImage() {
    setState(() {
      showFirst = !showFirst;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: AppPalette.inverseSurface,
            border: Border.all(color: AppPalette.outline),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: showFirst
                      ? Image.asset(
                          widget.firstImagePath,
                          key: const ValueKey("img1"),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Image.asset(
                          widget.secondImagePath,
                          key: const ValueKey("img2"),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.lightSurface.withAlpha(155),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                    ),
                    onPressed: _toggleImage,
                    child: const Icon(Icons.swap_horiz, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
