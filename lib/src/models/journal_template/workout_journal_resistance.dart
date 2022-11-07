// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class WorkoutJournalStrength {
//   String exerciseName;
//   int sequence;
//   String exerciseType = '';
//   List<double> weights = [];
//   List<int> reps = [];
//
//   DocumentReference? reference;
//
//   WorkoutJournalStrength({
//     required this.exerciseName,
//     required this.sequence,
//     required this.exerciseType,
//     required this.weights,
//     required this.reps,
//     this.reference,
//   });
//
//   factory WorkoutJournalStrength.fromFireStore(
//       Map<dynamic, dynamic> fireStore) =>
//       _exerciseFromFirestore(fireStore);
//
//   Map<String, dynamic> toMap() => _exerciseToJson(this);
//
//   @override
//   String toString() => "WorkoutJournalStrength<$exerciseName>";
// }
//
// WorkoutJournalStrength _exerciseFromFirestore(
//     Map<dynamic, dynamic> fireStore) {
//   return WorkoutJournalStrength(
//     exerciseName: fireStore['exerciseName'] as String,
//     sequence: fireStore['sequence'],
//     exerciseType: fireStore['exerciseType'] as String,
//     weights: fireStore['weights'].cast<double>(),
//     reps: fireStore['reps'].cast<int>(),
//   );
// }
//
// Map<String, dynamic> _exerciseToJson(WorkoutJournalStrength instance) =>
//     <String, dynamic>{
//       'exerciseName': instance.exerciseName,
//       'sequence': instance.sequence,
//       'exerciseType': instance.exerciseType,
//       'weights': instance.weights,
//       'reps': instance.reps,
//     };
