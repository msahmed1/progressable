// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:sport_journal/src/models/journal_template/workout_journal_aerobic.dart';
// import 'package:sport_journal/src/models/journal_template/workout_journal_strength.dart';
//
// class WorkoutJournal {
//   String workoutName;
//   List<WorkoutJournalStrength> strengthExercises = [];
//   List<WorkoutJournalAerobic> aerobicExercise = [];
//   String notes;
//   DateTime date;
//   int duration; // Save as two numbers, hours and minutes
//   // Can calculate total volume after retrieving all workout data, it is only used in history
//   int totalVolume;
//
//   String workoutID;
//   String userID;
//
//   WorkoutJournal({
//     required this.workoutName,
//     required this.strengthExercises,
//     required this.aerobicExercise,
//     required this.notes,
//     required this.date,
//     required this.duration,
//     required this.totalVolume,
//     required this.workoutID,
//     required this.userID,
//   });
//
//   factory WorkoutJournal.fromSnapshot(DocumentSnapshot snapshot) {
//     return WorkoutJournal.fromFireStore(snapshot.data() as Map<String, dynamic>);
//   }
//
//   factory WorkoutJournal.fromFireStore(Map<String, dynamic> fireStore) =>
//       _workoutsFromFirestore(fireStore);
//
//   Map<String, dynamic> toMap() => _workoutToMap(this);
//
//   @override
//   String toString() => "WorkoutLog<$workoutName>";
// }
//
// WorkoutJournal _workoutsFromFirestore(Map<String, dynamic> fireStore) {
//   return WorkoutJournal(
//     workoutName: fireStore['workoutName'] as String,
//     strengthExercises:
//     _convertExercises(fireStore['strengthExercises'] as List),
//     aerobicExercise:
//     _convertAerobic(fireStore['aerobicExercise'] as List),
//     notes: fireStore['notes'] as String,
//     date: fireStore['date'].toDate(),
//     duration: fireStore['duration'],
//     totalVolume: fireStore['totalVolume'],
//     workoutID: fireStore['workoutID'],
//     userID: fireStore['userID'] as String,
//   );
// }
//
// List<WorkoutJournalStrength> _convertExercises(List exerciseMap) {
//   if (exerciseMap.isEmpty) {
//     return [];
//   }
//   List<WorkoutJournalStrengthe> exercises = [];
//   for (var value in exerciseMap) {
//     exercises.add(WorkoutJournalStrength.fromFireStore(value));
//   // }
//   return exercises;
// }
//
// List<WorkoutJournalAerobic> _convertAerobics(List aerobicMap) {
//   if (aerobicMap.isEmpty) {
//     return [];
//   }
//   List<WorkoutJournalAerobic> aerobics = [];
//   for (var value in aerobicMap) {
//     aerobics.add(WorkoutJournalAerobic.fromFireStore(value));
//   }
//   return aerobics;
// }
//
// Map<String, dynamic> _workoutToMap(WorkoutJournal instance) =>
//     <String, dynamic>{
//       'workoutName': instance.workoutName,
//       'strengthExercises': _exerciseList(instance.strengthExercises),
//       'aerobicExercise': _aerobicList(instance.AerobicExercise),
//       'notes': instance.notes,
//       'date': instance.date,
//       'duration': instance.duration,
//       'totalVolume': instance.totalVolume,
//       'workoutID': instance.workoutID,
//       'userID': instance.userID,
//     };
//
// List<Map<String, dynamic>> _exerciseList(
//     List<WorkoutJournalStrength> exercises) {
//   if (exercises.isEmpty) {
//     return [];
//   }
//   List<Map<String, dynamic>> exerciseMap = [];
//   for (var exercise in exercises) {
//     exerciseMap.add(exercise.toMap());
//   }
//   return exerciseMap;
// }
//
// List<Map<String, dynamic>> _aerobicList(List<WorkoutJournalAerobic> aerobics) {
//   if (aerobics.isEmpty) {
//     return [];
//   }
//   List<Map<String, dynamic>> aerobicsMap = [];
//   for (var aerobic in aerobics) {
//     aerobicsMap.add(aerobic.toMap());
//   }
//   return aerobicsMap;
// }
