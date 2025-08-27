import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nextrep/core/entities/challenges/challenge.dart';

class FirebaseChallengeService {
  final _fireStore = FirebaseFirestore.instance;

  /// Get the document path for the current user
  DocumentReference getProfileDoc(String uid) {
    return _fireStore.collection('challenges').doc(uid);
  }

  Future<void> uploadProfileChallenges(
    String uid,
    List<Challenge> challenges,
  ) async {
    final jsonList = challenges.map((c) => c.toJson()).toList();

    await getProfileDoc(uid).set({
      'challenges': jsonList,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Challenge>?> fetchProfileChallenges(String uid) async {
    final doc = await getProfileDoc(uid).get();

    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    final challengeList = (data['challenges'] as List<dynamic>?);

    if (challengeList == null) return [];

    return challengeList.map((json) => Challenge.fromJson(json)).toList();
  }

  Future<void> deleteChallenges(String uid) async {
    final doc = await getProfileDoc(uid).get();
    if (doc.exists) {
      await getProfileDoc(uid).delete();
    }
  }
}
