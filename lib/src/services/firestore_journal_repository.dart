// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:success_program_app/src/blocs/auth_bloc.dart';
// import 'package:success_program_app/src/models/journal_template/workout_journal.dart';
//
// //DataRepository is used to isolate the usage of Firebase as much as possible
// class LoggerRepository {
//   //create a reference to top level collection
//   final CollectionReference loggerCollection =
//   FirebaseFirestore.instance.collection('userData');
//
//   //listen for updates automatically
//   Stream<List<WorkoutJournal>> getStream(BuildContext context) async* {
//     final uid = await Provider.of<AuthBloc>(context).getCurrentUID;
//     yield* loggerCollection
//         .doc(uid)
//         .collection('logger')
//         .orderBy('date', descending: true)
//         .limit(10)
//         .snapshots()
//         .map((query) => query.docs)
//         .map((snapshot) => snapshot
//         .map((document) => WorkoutJournal.fromFireStore(document.data()))
//         .toList());
//   }
//
//   //add a new workout, 'add' automatically creates a new document id for us
//   Future<DocumentReference> addWorkout(WorkoutJournal workout) async {
//     return loggerCollection
//         .doc(workout.userID)
//         .collection('journal')
//         .add(workout.toMap());
//   }
//
//   void deleteData(BuildContext context, DocumentReference documentID) async {
//     final uid = await Provider.of<AuthBloc>(context).getCurrentUID;
//     await loggerCollection
//         .doc(uid)
//         .collection('journal')
//         .doc(documentID.id)
//         .delete();
//   }
//
// //update workout class never used
// //  updateWorkout(WorkoutLog workout) async {
// //    await loggerCollection
// //        .document(workout.reference.documentID)
// //        .updateData(workout.toJson());
// //  }
// }
