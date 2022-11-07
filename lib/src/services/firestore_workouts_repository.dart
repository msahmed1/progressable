import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_journal/src/models/workout_planning_template/a_workout.dart';

//DataRepository is used to isolate the usage of Firebase as much as possible

class ProgrammesRepository {
  //create a reference to top level collection
  final CollectionReference _workoutsCollection =
      FirebaseFirestore.instance.collection('users');

  // listen for updates automatically and return updated list of routines
  Stream<List<AWorkout>> getWorkoutPrograms(String userID) {
    return _workoutsCollection
        .doc(userID)
        .collection('workouts')
        .snapshots()
        .map((query) => query.docs)
        .map(
          (snapshot) => snapshot
              .map((document) => AWorkout.fromFireStore(document.data()))
              .toList(),
        );
  }

  Future<AWorkout> getAWorkout(String userID, String workoutID) {
    return _workoutsCollection
        .doc(userID)
        .collection('workouts')
        .doc(workoutID)
        .get()
        .then((snapshot) => AWorkout.fromFireStore(snapshot.data()!));
  }

  // Stream<List<AWorkout>> queryWorkoutCycles({
  //   required String userID,
  //   required String trainingProgramName,
  // }) async* {
  //   yield* _workoutsCollection
  //       .doc(userID)
  //       .collection('workouts')
  //       .where('trainingCycle', isEqualTo: trainingProgramName)
  //       .snapshots()
  //       .map((query) => query.docs)
  //       .map(
  //         (snapshot) => snapshot
  //             .map((document) => AWorkout.fromFireStore(document.data()))
  //             .toList(),
  //       );
  // }

  //add a new workout, 'add' automatically creates a new document id for us
  Future<void> setWorkout(AWorkout workout) {
    return _workoutsCollection
        .doc(workout.userID)
        .collection('workouts')
        .doc(workout.workoutID)
        .set(workout.toMap());
  }

  //update workout class
  // updateWorkout(AWorkout workout) async {
  //   await _workoutsCollection
  //       .doc(workout.userID)
  //       .collection('workouts')
  //       .doc(workout.workoutID)
  //       .update(workout.toMap());
  // }

  Future<void> deleteData(AWorkout workout) async {
    await _workoutsCollection
        .doc(workout.userID)
        .collection('workouts')
        .doc(workout.workoutID)
        .delete();
  }
}
