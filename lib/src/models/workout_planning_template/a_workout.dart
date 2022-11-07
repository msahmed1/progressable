import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercise_journal/src/models/workout_planning_template/aerobic_training.dart';
import 'package:exercise_journal/src/models/workout_planning_template/strength_training.dart';

class AWorkout {
  String workoutName = '';

  List<Map<String, StrengthTraining>> strengthExercises = [];
  List<Map<String, AerobicTraining>> aerobicExercises = [];

  List<bool> activeDays = List<bool>.generate(7, (int index) => false);
  bool archive = false;

  //reference to fire store document representing this workout
  String workoutID = '';
  String userID = '';

  String workoutNote;

  int workoutDuration;
  // String workoutType;

  //**************************************************************************\\
  //***************************** Constructor ********************************\\
  //**************************************************************************\\
  AWorkout({
    required this.workoutName,
    required this.strengthExercises,
    required this.aerobicExercises,
    required this.activeDays,
    this.archive = false,
    required this.workoutID,
    required this.userID,
    required this.workoutNote,
    required this.workoutDuration,
  });

  //factory constructor to create a workout from a fireStore documentSnapshot,
  //the reference is saved for updating later
  factory AWorkout.fromSnapshot(DocumentSnapshot snapshot) {
    return AWorkout.fromFireStore(snapshot.data() as Map<String, AWorkout>);
  }

  //factory constructor for creating a workout from json
  factory AWorkout.fromFireStore(Map<String, dynamic> fireStore) =>
      _workoutFromFirestore(fireStore);

  //turn this workout into a map of key/value pairs
  Map<String, dynamic> toMap() => _workoutToMap(this);

  @override
  String toString() => "AWorkout<$workoutName>";
}

//helper functions below

//function for converting a map of key/value pairs into a workout
AWorkout _workoutFromFirestore(Map<String, dynamic> fireStore) {
  return AWorkout(
    workoutName: fireStore['workoutName'] as String,
    strengthExercises: _convertStrengthExercises(
      fireStore['strengthExercises'] as List<dynamic>,
    ),
    aerobicExercises: _convertAerobics(
      fireStore['aerobicExercises'] as List<dynamic>,
    ),
    //No idea why I have to cast to a bool to get this to work
    activeDays: List<bool>.from(fireStore['activeDays'] as List),
    archive: fireStore['archive'] as bool,
    workoutID: fireStore['workoutID'] as String,
    userID: fireStore['userID'] as String,
    workoutNote: fireStore['workoutNote'] as String,
    workoutDuration: fireStore['workoutDuration'] as int,
  );
}

//function to convert a list of maps containing maps into a list of maps containing exercises
List<Map<String, StrengthTraining>> _convertStrengthExercises(
  List strengthExerciseList,
) {
  if (strengthExerciseList.isEmpty || strengthExerciseList == []) {
    //Sometimes flutter cant recognise a list as .isEmpty, therefore both conditions present
    return <Map<String, StrengthTraining>>[];
  }

  //Go through the list of strength exercises and format them correctly
  List<Map<String, StrengthTraining>> listOfExercises = [];
  for (final subExercisesList in strengthExerciseList) {
    Map<String, StrengthTraining> allSubstitutes = {};
    subExercisesList.forEach((key, exercise) {
      final StrengthTraining aSubstitute =
          StrengthTraining.fromFireStore(exercise as Map<dynamic, dynamic>);
      allSubstitutes[key as String] = aSubstitute;
      // StrengthTraining.fromFireStore(exercise);
    });
    // for (var exercise in subExercisesList.values) {
    //   // subExercisesList[value.key] = value.value;
    //   allSubstitutes[exercise['subSequence'].toString()] =
    //       StrengthTraining.fromFireStore(exercise);
    //   print('allSubstitutes[exercise[\'subSequence\']]: ${allSubstitutes[exercise['subSequence'].toString()]}');
    // }
    listOfExercises.add(allSubstitutes);
  }
  // The data has already been ready from firestore but it needs to be formatted correctly
  // That is where WorkoutJournalStrength.fromFireStore(value) comes into play
  // it is what formats the value into something that is usable.
  return listOfExercises;
}

//function for converting a map of key/value pairs into a workout
List<Map<String, AerobicTraining>> _convertAerobics(List aerobicExerciseList) {
  if (aerobicExerciseList.isEmpty || aerobicExerciseList == []) {
    //If its is empty do I not return something more than an empty string? like an empty workout?
    return <Map<String, AerobicTraining>>[];
  }

  List<Map<String, AerobicTraining>> listOfExercises = [];
  for (final subExercisesList in aerobicExerciseList) {
    Map<String, AerobicTraining> allSubstitutes = {};
    subExercisesList.forEach((key, exercise) {
      final AerobicTraining aSubstitute =
          AerobicTraining.fromFireStore(exercise as Map<dynamic, dynamic>);
      allSubstitutes[key as String] = aSubstitute;
    });
    listOfExercises.add(allSubstitutes);
  }

  return listOfExercises;
}

//convert a workout into a map of key/value pairs to store in firebase
Map<String, dynamic> _workoutToMap(AWorkout workout) => <String, dynamic>{
      'workoutName': workout.workoutName,
      'strengthExercises': _strengthList(workout.strengthExercises),
      'aerobicExercises': _aerobicList(workout.aerobicExercises),
      'activeDays': workout.activeDays,
      'archive': workout.archive,
      'workoutID': workout.workoutID,
      'userID': workout.userID,
      'workoutNote': workout.workoutNote,
      'workoutDuration': workout.workoutDuration,
    };

// convert a list of exercises into a list of mapped values
// I don't think I need to wrap everything in a list instead use a list or maps
List<Map<String, Map<String, dynamic>>> _strengthList(
  List<Map<String, StrengthTraining>> strengthExercises,
) {
  //If there are no strength exercises
  if (strengthExercises.isEmpty) {
    return <Map<String, Map<String, dynamic>>>[];
  }

  // If there are strength exercises
  // Create local variable to store the formatted strength exercises
  List<Map<String, Map<String, dynamic>>> exerciseList = [];
  //Go through each exercise
  for (final subSequence in strengthExercises) {
    Map<String, Map<String, dynamic>> temp = {};
    //Go through each substitute exercise
    subSequence.forEach((subSequencePos, exercise) {
      temp[subSequencePos] = exercise.toMap();
    });
    exerciseList.add(temp);
  }

  return exerciseList;
}

List<Map<String, dynamic>> _aerobicList(
  List<Map<String, AerobicTraining>> aerobicExercises,
) {
  if (aerobicExercises.isEmpty) {
    return <Map<String, Map<String, dynamic>>>[];
  }

  List<Map<String, Map<String, dynamic>>> exerciseList = [];
  for (final subSequence in aerobicExercises) {
    Map<String, Map<String, dynamic>> temp = {};
    subSequence.forEach((subSequencePos, exercise) {
      temp[subSequencePos] = exercise.toMap();
    });
    exerciseList.add(temp);
  }
  return exerciseList;
}
