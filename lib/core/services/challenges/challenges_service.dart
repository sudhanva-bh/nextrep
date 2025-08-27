import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nextrep/core/data/preset_challenges.dart';
import 'package:nextrep/core/entities/challenges/challenge.dart';

class ChallengesService {
  final box = Hive.box<Challenge>('challengesBox');

  /// Retrieves a single [Challenge] from Hive by its [title].
  Challenge? getChallenge(String title) {
    return box.get(title);
  }

  /// Returns a list of all stored [Challenge]s from Hive.
  List<Challenge> getAllChallenges() {
    return box.values.toList();
  }

  /// Searches and returns a list of [Challenge]s whose names
  /// contain the given [query] (case-insensitive).
  List<Challenge> searchChallenges(String query) {
    final lowerQuery = query.toLowerCase();
    return box.values
        .where(
          (challenge) => challenge.title.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  /// Updates an existing [Challenge] in Hive.
  /// If the challenge does not exist, this will add it as new.
  Future<void> updateChallenge(Challenge challenge) async {
    await box.put(challenge.title, challenge);
  }

  /// Uploads a new [Challenge] to Hive if it doesn't already exist.
  /// Shows a snackbar with success or error message accordingly.
  Future<void> uploadNewChallenge(Challenge challenge) async {
    if (box.containsKey(challenge.title)) {
      // showSnackBar(context, "Challenge ${challenge.title} Already Exists");
    } else {
      await box.put(challenge.title, challenge);
      // if (context.mounted) {
      //   showSnackBar(context, "Updated ${challenge.title} Successfully");
      // }
    }
  }

  /// Updates all the given [challenges] in Hive.
  /// Existing entries with matching titles will be overwritten.
  /// If a challenge is new, it will be added.
  /// No existing data will be deleted.
  Future<void> updateAllChallenges(List<Challenge> challenges) async {
    final Map<String, Challenge> entriesToUpdate = {
      for (var challenge in challenges) challenge.title: challenge,
    };

    await box.putAll(entriesToUpdate);
  }

  Future<void> putPresetChallenges() async {
    if (box.isEmpty) {
      for (final challenge in PresetChallenges.challenges) {
        await box.put(challenge.title, challenge);
      }
      debugPrint('✅ Preset Challenges cached in Hive');
    } else {
      debugPrint('📦 Preset Challenges already cached');
    }
  }

  /// Converts all local Hive challenges to a JSON List.
  /// Useful for uploading to Firebase Firestore.
  List<Map<String, dynamic>> getAllChallengesAsJson() {
    return box.values.map((challenge) => challenge.toJson()).toList();
  }

  /// Deletes all stored [Challenge]s from Hive.
  Future<void> deleteAllChallenges() async {
    await box.clear();
  }
}
