import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nextrep/core/constants/widget_properties.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class YouTubeEmbed extends StatefulWidget {
  final Exercise exercise;

  const YouTubeEmbed({super.key, required this.exercise});

  @override
  State<YouTubeEmbed> createState() => _YouTubeEmbedState();
}

class _YouTubeEmbedState extends State<YouTubeEmbed> {
  YoutubePlayerController? _controller;
  bool _isLoading = false;
  String? _error;

  Future<void> _searchAndPlay() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiKey = dotenv.env['YOUTUBE_API_KEY'];
      final query = "${widget.exercise.name} Tutorial";
      final url =
          "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=1&q=$query&key=$apiKey";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception("Failed to load YouTube data");
      }

      final data = jsonDecode(response.body);
      final videoId = data["items"][0]["id"]["videoId"];

      setState(() {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: true),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Still loading video
    if (_isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: AppPalette.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppPalette.outlineEnabled, width: 1),
          boxShadow: WidgetProperties.dropShadow,
        ),
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: AppPalette.primary),
        ),
      );
    }

    // 2. Error state
    if (_error != null) {
      return Container(
        decoration: BoxDecoration(
          color: AppPalette.error,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Text(
          "Error: $_error",
          style: const TextStyle(color: AppPalette.onError),
        ),
      );
    }

    // 3. After video is loaded, show the player
    if (_controller != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppPalette.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppPalette.outlineEnabled, width: 1),
            boxShadow: WidgetProperties.dropShadow,
          ),
          child: YoutubePlayer(
            controller: _controller!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: AppPalette.primary,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(
                isExpanded: true,
                colors: ProgressBarColors(
                  playedColor: AppPalette.primary,
                  handleColor: AppPalette.inversePrimary,
                  bufferedColor: AppPalette.lightSurface,
                  backgroundColor: AppPalette.outline,
                ),
              ),
              RemainingDuration(),
              const SizedBox(height: 5),
            ],
          ),
        ),
      );
    }

    // 4. Initial state: just a play button
    return GestureDetector(
      onTap: _searchAndPlay,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppPalette.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppPalette.outlineEnabled, width: 1),
          boxShadow: WidgetProperties.dropShadow,
        ),
        child: const Center(
          child: Icon(
            Icons.play_circle_fill,
            color: AppPalette.primary,
            size: 64,
          ),
        ),
      ),
    );
  }
}
