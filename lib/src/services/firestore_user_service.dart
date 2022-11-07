import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_journal/src/models/user.dart';
// import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // The belo code should do the same thing and reduce repetition
  //final CollectionReference _workoutsCollection =
  //       FirebaseFirestore.instance.collection('users');

  Future<void> setUser(UserData user) {
    return _db.collection('users').doc(user.userId).set(user.toMap());
  }

  Future<void> setAccountType({required String uid, required String type}) {
    return _db.collection('users').doc(uid).update({
      type: true,
    });
  }

  Future<void> updateHealthData({
    required String userId,
    required double height,
    required double weight,
    required int age,
  }) {
    return _db.collection('users').doc(userId).update({
      'height': height,
      'weight': weight,
      'age': age,
    });
  }

  Future<void> updateEmailVerified({
    required String userId,
    required bool verified,
  }) {
    return _db.collection('users').doc(userId).update({'verified': verified});
  }

  // Use .update() to update only a single field in firebase cloud fireStore
  Future<void> updateWorkoutCount({
    required int workoutCounter,
    required String userId,
  }) {
    return _db
        .collection('users')
        .doc(userId)
        .update({'workoutCount': workoutCounter});
  }

  Future<UserData> getUser(String userId) {
    // If I some how get a userID but no data exists in fireStore, fireStore returns null
    // This could happen if I delete the users data in fireStore and they want to re-make an account
    // This could also happen if the user data is deleted and somehow app data persists on phone, maybe this is just a simulator issue as I'm not deleting the app from the phone before uploading a new version of the code for testing.
    return _db
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) => UserData.fromFirestore(snapshot.data()!));
  }

  Stream<UserData>? getUserData(String? userId) {
    // If I some how get a userID but no data exists in fireStore, fireStore returns null
    // This could happen if I delete the users data in fireStore and they want to re-make an account
    // This could also happen if the user data is deleted and somehow app data persists on phone, maybe this is just a simulator issue as I'm not deleting the app from the phone before uploading a new version of the code for testing.
    if(userId == null){
      return null;
    }
    return _db
        .collection('users')
        .doc(userId)
        .snapshots()
        // .map((query) => query.docs)
        .map((snapshot) => UserData.fromFirestore(snapshot.data()!));
  }

  Future deleteUser({required String userId}) {
    return _db.collection('users').doc(userId).delete();
  }
}
