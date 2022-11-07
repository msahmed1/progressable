// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class WorkoutJournalAerobic {
//   String exerciseName;
//   int sequence;
//   String exerciseType = '';
//   int distance;
//   int duration;
//   int calories;
//
//   //reference to firestore document representing the exercise
//   DocumentReference? reference;
//
//   WorkoutJournalAerobic({
//     required this.exerciseName,
//     required this.sequence,
//     required this.exerciseType,
//     required this.distance,
//     required this.duration,
//     this.reference,
//     required this.calories,
//   });
//
//   factory WorkoutJournalAerobic.fromFireStore(Map<dynamic, dynamic> fireStore) =>
//       _aerobicFromFirestore(fireStore);
//
//   Map<String, dynamic> toMap() => _aerobicToMap(this);
//
//   @override
//   String toString() => "WorkoutJournalaerobic<$exerciseName>";
// }
//
// //turns a map of values from firestore into a exercise class
// WorkoutJournalAerobic _aerobicFromFirestore(Map<dynamic, dynamic> fireStore) {
//   return WorkoutJournalAerobic(
//     exerciseName: fireStore['exerciseName'] as String,
//     sequence: fireStore['sequence'],
//     exerciseType: fireStore['exerciseType'] as String,
//     distance: fireStore['distance'],
//     duration: fireStore['duration'],
//     calories: fireStore['calories'],
//   );
// }
//
// //converts the exercise class into a map of key/value pairs
// Map<String, dynamic> _aerobicToMap(WorkoutJournalAerobic instance) =>
//     <String, dynamic>{
//       'exerciseName': instance.exerciseName,
//       'sequence': instance.sequence,
//       'exerciseType': instance.exerciseType,
//       'distance': instance.distance,
//       'duration': instance.duration,
//       'calories' : instance.calories,
//     };
