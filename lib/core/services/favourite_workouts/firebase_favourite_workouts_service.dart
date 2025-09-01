import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nextrep/core/entities/workout/workout.dart';

class FirebaseFavouriteExerciseService {
  final _fireStore = FirebaseFirestore.instance;

  DocumentReference getProfileDoc(String uid) {
    return _fireStore.collection('favouriteWorkouts').doc(uid);
  }

  Future<void> uploadProfileWorkouts(
    String uid, List<Workout> workouts,
  ) async {
    final jsonList = workouts.map((c) => c.toJson()).toList();

    await getProfileDoc(uid).set({
      'favouriteWorkouts': jsonList,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Workout>?> fetchProfileWorkouts(String uid) async {
    final doc = await getProfileDoc(uid).get();

    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    final List<dynamic> challengeList = data['favouriteWorkouts'];

    return challengeList.map((json) => Workout.fromJson(json)).toList();
  }

  Future<void> deleteWorkout(String uid) async {
    await getProfileDoc(uid).delete();
  }
}
