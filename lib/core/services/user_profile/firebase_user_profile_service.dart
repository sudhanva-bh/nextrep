import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nextrep/core/entities/user/user_profile_model.dart';

class FirebaseUserProfileService {
  final _fireStore = FirebaseFirestore.instance;

  /// Get the document path for the current user
  DocumentReference getUserDoc(String uid) {
    return _fireStore.collection('users').doc(uid);
  }

  /// Upload (create or overwrite) profile to Firestore
  Future<void> uploadProfile(String uid, UserProfile profile) async {
    await getUserDoc(uid).set(profile.toMap());
  }

  /// Fetch profile from Firestore
  Future<UserProfile?> fetchProfile(String uid) async {
    final doc = await getUserDoc(uid).get();

    if (!doc.exists) return null;

    final data = doc.data();
    if (data is! Map<String, dynamic>) return null;

    return UserProfile.fromMap(data);
  }

  /// Update specific fields in Firestore (without overwriting)
  Future<void> updateProfileFields(
    String uid,
    Map<String, dynamic> fields,
  ) async {
    await getUserDoc(uid).update(fields);
  }

  /// Delete profile from cloud
  Future<void> deleteProfile(String uid) async {
    await getUserDoc(uid).delete();
  }
}
