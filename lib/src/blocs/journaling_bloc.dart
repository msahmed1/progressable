import 'dart:async';

import 'package:exercise_journal/src/models/workout_planning_template/a_workout.dart';
import 'package:exercise_journal/src/models/workout_planning_template/aerobic_training.dart';
import 'package:exercise_journal/src/models/workout_planning_template/strength_training.dart';
import 'package:exercise_journal/src/services/firestore_workouts_repository.dart';

// import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class JournalingBloc {
  //****************** reference to top level collection *********************\\
  // For now I'm using the same document as the workout_planning_bloc however
  // in the future when the user upgrades to a more premium account I'll start
  // saving a history document.
  final db = ProgrammesRepository();

  //***************************** Cache values ********************************\\
  final _currentWorkout = BehaviorSubject<AWorkout>();
  final _aWorkoutName = BehaviorSubject<String>();
  final _aerobicTrainingList =
      BehaviorSubject<List<Map<int, AerobicTraining>>>();
  final _strengthTrainingList =
      BehaviorSubject<List<Map<int, StrengthTraining>>>();

  // final _substituteSequence = BehaviorSubject<List<dynamic>>();
  //
  //*********************** Edit Exercise Parameters **************************\\
  final _duration = BehaviorSubject<int>();
  final _enableDuration = BehaviorSubject<bool>();
  final _distance = BehaviorSubject<String?>();
  final _weight = BehaviorSubject<String?>();
  final _reps = BehaviorSubject<String?>();
  final _currentSet = BehaviorSubject<int>();
  final _currentExerciseName = BehaviorSubject<String>();
  final _currentWorkoutNote = BehaviorSubject<String>();
  final _exerciseNote = BehaviorSubject<String>();
  final _rateOfPerceivedExertion = BehaviorSubject<String>();
  final _enableRPE = BehaviorSubject<bool>();
  final _enableCalories = BehaviorSubject<bool>();
  final _calories = BehaviorSubject<String?>();

  //*********************** Summary **************************\\
  final _totalVolume = BehaviorSubject<double>();

  //****************************** Notifiers *********************************\\
  //publish subject does not save last value once used its goes back to being blank
  final _substituteSaved = PublishSubject<bool>();
  final _aWorkoutSaved = PublishSubject<bool>();

  //**************************************************************************\\
  //******************************* Getters **********************************\\
  //**************************************************************************\\

  Stream<List<dynamic>> get orderedTargets =>
      _currentWorkout.stream.transform(orderTargetExercises);

  Stream<List<dynamic>> get orderedActual => CombineLatestStream.combine2(
          // use combineLatest() instead
          _strengthTrainingList,
          _aerobicTrainingList, (strengthExercise, aerobicExercise) {
        // 1. Create a Map to store all exercises
        final Map<int, dynamic> sequenceOfExercise = <int, dynamic>{};

        // 2. Get all exercises into one list
        final List<dynamic> listOfAllExerciseTypes =
            List.from(_strengthTrainingList.value)
              ..addAll(_aerobicTrainingList.value);

        // 3. Add all exercises the Map
        for (final mapOfAllExercises in listOfAllExerciseTypes) {
          sequenceOfExercise[mapOfAllExercises[0].sequence as int] =
              mapOfAllExercises[0];
        }

        // 4. Get all the keys for the Map and sort them
        final sortedKeys = sequenceOfExercise.keys.toList()..sort();

        // 5. retrieve data via sorted keys
        // and return add all sorted keys to a separate map
        final List<dynamic> orderedSequenceOfExercise = <dynamic>[];
        for (final int key in sortedKeys) {
          orderedSequenceOfExercise.add(sequenceOfExercise[key]);
        }

        return orderedSequenceOfExercise;
      });

  ValueStream<AWorkout> get aWorkout => _currentWorkout.stream;

  Stream<String> get workoutName => _aWorkoutName.stream.distinct();

  // .distinct() only publish unique values

  Stream<int> get duration => _duration.stream;

  Stream<bool> get enableDuration => _enableDuration.stream;

  Stream<int> get distance => _distance.stream.transform(validateDistance);

  Stream<double> get weight => _weight.stream.transform(validateWeight);

  Stream<int> get reps => _reps.stream.transform(validateReps);

  Stream<bool> get workoutSaved => _aWorkoutSaved.stream;

  Stream<bool> get substituteSaved => _substituteSaved.stream;

  Stream<String> get currentExerciseName => _currentExerciseName.stream;

  Stream<String> get workoutNote => _currentWorkoutNote.stream
      .transform(validateNote)
      .debounceTime(const Duration(milliseconds: 500));

  Stream<String> get exerciseNote => _exerciseNote.stream
      .transform(validateNote)
      .debounceTime(const Duration(milliseconds: 500));

  Stream<double> get totalVolume => _totalVolume.stream;

  Stream<int> get rateOfPerceivedExertion =>
      _rateOfPerceivedExertion.stream.transform(validateRPE);

  Stream<bool> get enableRPE => _enableRPE.stream;

  Stream<bool> get enableCalories => _enableCalories.stream;

  Stream<int> get calories => _calories.stream.transform(validateCalories);

  //**************************************************************************\\
  //******************************* Setters **********************************\\
  //**************************************************************************\\

  // Function(Map<int, List<AerobicTraining>>)
  //     get changeStrengthTrainingMap => _aerobicTrainingMap.sink.add;
  //
  // Function(Map<int, List<StrengthTraining>>)
  //     get changeAerobicTrainingList => _strengthTrainingList.sink.add;

  Function(int) get changeDuration => _duration.sink.add;

  Function(bool) get changeEnableDuration => _enableDuration.sink.add;

  Function(String?) get changeDistance => _distance.sink.add;

  Function(String?) get changeWeight => _weight.sink.add;

  Function(String?) get changeRep => _reps.sink.add;

  Function(int) get changeCurrentSet => _currentSet.sink.add;

  Function(String) get changeExerciseName => _currentExerciseName.sink.add;

  Function(String) get changeWorkoutNote => _currentWorkoutNote.sink.add;

  Function(String) get changeExerciseNote => _exerciseNote.sink.add;

  Function(String) get changeRPE => _rateOfPerceivedExertion.sink.add;

  Function(bool) get changeEnableRPE => _enableRPE.sink.add;

  Function(bool) get changeEnableCalories => _enableCalories.sink.add;

  Function(String?) get changeCalories => _calories.sink.add;

  //**************************************************************************\\
  //****************************** Validators *********************************\\
  //**************************************************************************\\

  final validateWeight = StreamTransformer<String?, double>.fromHandlers(
    handleData: (exerciseWeight, sink) {
      if (exerciseWeight != null) {
        try {
          if (exerciseWeight == '') {
            sink.addError("Please enter weight lifted");
          } else if (exerciseWeight.contains('.')) {
            if (exerciseWeight.split('.')[1].length > 2) {
              sink.addError("Enter a valid number to 2 decimal places");
            } else if (double.parse(exerciseWeight) > 1000.0) {
              sink.addError("Weight cant be greater than 1000kg");
            } else if (double.parse(exerciseWeight) == 0) {
              sink.addError("Weight must be greater than 0");
            } else {
              //TODO: I will probably have to do some error checking here as sometimes the conversation from double to string fails as the conversion is not perfect
              sink.add(double.parse(exerciseWeight));
            }
          } else if (double.parse(exerciseWeight) > 1000.0) {
            sink.addError("Weight cant be greater than 1000kg");
          } else if (double.parse(exerciseWeight) == 0) {
            sink.addError("Weight must be greater than 0");
          } else {
            sink.add(double.parse(exerciseWeight));
          }
        } catch (error) {
          sink.addError('Enter a valid number');
        }
      }
    },
  );

  final validateReps = StreamTransformer<String?, int>.fromHandlers(
    handleData: (exerciseRep, sink) {
      if (exerciseRep != null) {
        try {
          if (exerciseRep == '') {
            sink.addError("Please enter reps performed");
          } else if (int.parse(exerciseRep) <= 99) {
            sink.add(int.parse(exerciseRep));
          } else if (int.parse(exerciseRep) == 0) {
            sink.addError("Please must be greater than 0");
          } else {
            sink.addError("Reps can't be greater than 99");
          }
        } catch (error) {
          sink.addError('Must be a whole number');
        }
      }
    },
  );

  final validateDistance = StreamTransformer<String?, int>.fromHandlers(
    handleData: (exerciseDistance, sink) {
      if (exerciseDistance != null) {
        try {
          if (exerciseDistance == '') {
            sink.addError("Please enter distance");
          } else if (int.parse(exerciseDistance) > 99999) {
            sink.addError("Distance cant be greater than 99999");
          } else if (int.parse(exerciseDistance) == 0) {
            sink.addError("Distance must be greater than 0");
          } else {
            sink.add(int.parse(exerciseDistance));
          }
        } catch (error) {
          sink.addError('Must be a whole number');
        }
      }
    },
  );

  final validateCalories = StreamTransformer<String?, int>.fromHandlers(
    handleData: (calories, sink) {
      if (calories != null) {
        try {
          if (calories == '') {
            sink.addError('Please enter calories burnt');
          } else if (int.parse(calories) > 9999) {
            sink.addError('Calories cant be greater than 9999');
          } else if (int.parse(calories) == 0) {
            sink.addError('Calories must be greater than 0');
          } else {
            sink.add(int.parse(calories));
          }
        } catch (error) {
          sink.addError('Calories must be a whole number');
        }
      }
    },
  );

  final validateNote = StreamTransformer<String, String>.fromHandlers(
    handleData: (note, sink) {
      if (note != '') {
        try {
          // int count = '\n'.allMatches(note).length; //Used to count the number of lines in a string
          if (note.length > 500) {
            //Display error dialog somewhere
            sink.addError('note is too long');
          } else {
            sink.add(note);
          }
        } catch (error) {
          sink.addError('note is not valid');
        }
      }
    },
  );

  final validateRPE = StreamTransformer<String, int>.fromHandlers(
    handleData: (exerciseRep, sink) {
      if (exerciseRep != '') {
        try {
          if (int.parse(exerciseRep) <= 10) {
            sink.add(int.parse(exerciseRep));
          } else if (int.parse(exerciseRep) < 0) {
            sink.addError("RPE can't be greater than 0");
          } else {
            sink.addError("RPE can't be less than 10");
          }
        } catch (error) {
          sink.addError('Must be a whole number');
        }
      }
    },
  );

  Stream<bool> get isStrengthValid =>
      CombineLatestStream.combine2(weight, reps, (weight, reps) => true);

  Stream<bool> get isAerobicValid =>
      CombineLatestStream.combine2(distance, duration, (dist, dur) => true);

  //**************************************************************************\\
  //****************************** Functions *********************************\\
  //**************************************************************************\\

  //********************************** setup **********************************\\
  void setUpWorkoutJournaling(AWorkout workout) {
    _aWorkoutName.sink.add(workout.workoutName);

    // DON'T CREATE DIRECT COPIES OF OBJECTS(COLLECTIONS) AS THEY ARE PASSED BY REFERENCE
    //    Instead create and object and copy values in. Otherwise we will have unusual behaviour.

    // Set up list of strength exercises
    // _strengthTrainingList only accepts a map with int as key
    List<Map<int, StrengthTraining>> tempStrengthExerciseListInt = [];
    // aWorkout.strengthExercise only accepts Strings as key
    List<Map<String, StrengthTraining>> tempStrengthExerciseListString = [];
    Map<int, StrengthTraining> tempStrengthExerciseMapInt = {};
    Map<String, StrengthTraining> tempStrengthExerciseMapString = {};

    if (workout.strengthExercises != []) {
      // Go through each element in strengthExercise list and make a copy of it
      for (final sequenceOfExercises in workout.strengthExercises) {
        // go through all sub sequence and create strength objects to add to map
        sequenceOfExercises.forEach((key, element) {
          final StrengthTraining blankValues = StrengthTraining(
            strengthExerciseName: element.strengthExerciseName,
            sequence: element.sequence,
            subSequence: element.subSequence,
            exerciseType: element.exerciseType,
            trainingType: element.trainingType,
            sets: element.sets,
            targetReps: List<int>.filled(element.sets, 0),
            targetWeights: List<double>.filled(element.sets, 0),
            time: element.time,
            enableTime: element.enableTime,
            rateOfPerceivedExertion: element.rateOfPerceivedExertion,
            enableRPE: element.enableRPE,
            note: element.note,
          );
          tempStrengthExerciseMapInt[blankValues.subSequence] = blankValues;

          final StrengthTraining previousValues = StrengthTraining(
            strengthExerciseName: element.strengthExerciseName,
            sequence: element.sequence,
            subSequence: element.subSequence,
            exerciseType: element.exerciseType,
            trainingType: element.trainingType,
            sets: element.sets,
            targetReps: element.targetReps,
            targetWeights: element.targetWeights,
            time: element.time,
            enableTime: element.enableTime,
            rateOfPerceivedExertion: element.rateOfPerceivedExertion,
            enableRPE: element.enableRPE,
            note: element.note,
          );
          tempStrengthExerciseMapString[previousValues.subSequence.toString()] =
              previousValues;
        });
        // Add each sequence of exercise to a list
        tempStrengthExerciseListInt.add(tempStrengthExerciseMapInt);
        tempStrengthExerciseListString.add(tempStrengthExerciseMapString);
        // reinitialise place holder to prevent data persistence
        tempStrengthExerciseMapInt = {};
        tempStrengthExerciseMapString = {};
      }
    }
    //WARNING: _strengthTrainingList is not saved in order, as a result everytime it is used it it must be reordered.
    //    I can order the list here as it might save some headache in the future. but as a rule for safety I
    //    will have to make sure the order is checked everytime it is used
    _strengthTrainingList.sink.add(tempStrengthExerciseListInt);

    // Set up list of aerobic exercises
    // _aerobicTrainingList only accepts a map with int as key
    List<Map<int, AerobicTraining>> tempAerobicExerciseListInt = [];
    // aWorkout.aerobicExercise only accepts Strings as key
    List<Map<String, AerobicTraining>> tempAerobicExerciseListString = [];
    Map<int, AerobicTraining> tempAerobicExerciseMapInt = {};
    Map<String, AerobicTraining> tempAerobicExerciseMapString = {};

    if (workout.aerobicExercises != []) {
      // Go through each element in strengthExercise list and make a copy of it
      for (final sequenceOfExercises in workout.aerobicExercises) {
        // go through all sub sequence and create strength objects to add to map
        sequenceOfExercises.forEach((key, element) {
          final AerobicTraining blankValues = AerobicTraining(
            aerobicExerciseName: element.aerobicExerciseName,
            sequence: element.sequence,
            subSequence: element.subSequence,
            exerciseType: element.exerciseType,
            trainingType: element.trainingType,
            intervals: element.intervals,
            distance: [0],
            enableDistance: element.enableDistance,
            duration: [0],
            enableDuration: element.enableDuration,
            calories: element.calories,
            enableCalories: element.enableCalories,
            heartRateZone: element.heartRateZone,
            enableHeatRateZone: element.enableHeatRateZone,
            resistance: element.resistance,
            enableResistance: element.enableResistance,
            speed: element.speed,
            enableSpeed: element.enableSpeed,
            rateOfPerceivedExertion: element.rateOfPerceivedExertion,
            enableRPE: element.enableRPE,
            note: element.note,
          );
          tempAerobicExerciseMapInt[blankValues.subSequence] = blankValues;

          final AerobicTraining previousValues = AerobicTraining(
            aerobicExerciseName: element.aerobicExerciseName,
            sequence: element.sequence,
            subSequence: element.subSequence,
            exerciseType: element.exerciseType,
            trainingType: element.trainingType,
            intervals: element.intervals,
            distance: element.distance,
            enableDistance: element.enableDistance,
            duration: element.duration,
            enableDuration: element.enableDuration,
            calories: element.calories,
            enableCalories: element.enableCalories,
            heartRateZone: element.heartRateZone,
            enableHeatRateZone: element.enableHeatRateZone,
            resistance: element.resistance,
            enableResistance: element.enableResistance,
            speed: element.speed,
            enableSpeed: element.enableSpeed,
            rateOfPerceivedExertion: element.rateOfPerceivedExertion,
            enableRPE: element.enableRPE,
            note: element.note,
          );
          tempAerobicExerciseMapString[previousValues.subSequence.toString()] =
              previousValues;
        });
        // Add each sequence of exercise to a list
        tempAerobicExerciseListInt.add(tempAerobicExerciseMapInt);
        tempAerobicExerciseListString.add(tempAerobicExerciseMapString);
        // reinitialise place holder to prevent data persistence
        tempAerobicExerciseMapInt = {};
        tempAerobicExerciseMapString = {};
      }
    }
    _aerobicTrainingList.sink.add(tempAerobicExerciseListInt);

    _currentWorkoutNote.sink.add(workout.workoutNote);

    final AWorkout currentWorkout = AWorkout(
      workoutName: workout.workoutName,
      strengthExercises: tempStrengthExerciseListString,
      aerobicExercises: tempAerobicExerciseListString,
      activeDays: workout.activeDays,
      workoutID: workout.workoutID,
      userID: workout.userID,
      workoutNote: workout.workoutNote,
      workoutDuration: workout.workoutDuration,
    );

    _currentWorkout.sink.add(currentWorkout);
  }

  void loadNote(int sequence) {
    for (int i = 0; i < _strengthTrainingList.value.length; i++) {
      if ((_strengthTrainingList.value[i])[0]?.sequence == sequence) {
        _exerciseNote.sink.add((_strengthTrainingList.value[i])[0]?.note ?? '');
        break;
      }
    }
    for (int i = 0; i < _aerobicTrainingList.value.length; i++) {
      if ((_aerobicTrainingList.value[i])[0]?.sequence == sequence) {
        _exerciseNote.sink.add((_aerobicTrainingList.value[i])[0]?.note ?? '');
        break;
      }
    }
  }

  // This function is the exact same as in the workout_planning_bloc
  final orderTargetExercises =
      StreamTransformer<AWorkout, List<dynamic>>.fromHandlers(
    handleData: (workout, sink) {
      // 1. Create a Map to store all exercises
      Map<int, dynamic> sequenceOfExercise = <int, dynamic>{};
      // 2. Get all exercises into one list
      // List<dynamic> listOfAllExerciseTypes = workout.strengthExercises;
      final List<dynamic> listOfAllExerciseTypes =
          List.from(workout.strengthExercises)
            ..addAll(workout.aerobicExercises);

      // 3. Add all exercises the Map
      for (final mapOfAllExercises in listOfAllExerciseTypes) {
        sequenceOfExercise[mapOfAllExercises['0'].sequence as int] =
            mapOfAllExercises['0'];
      }

      // 4. Get all the keys for the Map and sort them
      final sortedKeys = sequenceOfExercise.keys.toList()..sort();

      // 5. retrieve data via sorted keys
      // and return add all sorted keys to a separate map
      List<dynamic> orderedSequenceOfExercise = <dynamic>[];
      for (final int key in sortedKeys) {
        orderedSequenceOfExercise.add(sequenceOfExercise[key]);
      }

      sink.add(orderedSequenceOfExercise);
    },
  );

  //******************************** Modifiers ********************************\\
  void updateAExercise({required int sequence, required String exerciseType}) {
    if (exerciseType == 'aerobic') {
      List<Map<int, AerobicTraining>> allAerobicExercises =
          _aerobicTrainingList.value;

      for (int i = 0; i < allAerobicExercises.length; i++) {
        if ((allAerobicExercises[i])[0]?.sequence == sequence) {
          (allAerobicExercises[i])[0]?.distance[0] =
              int.parse(_distance.value!);
          (allAerobicExercises[i])[0]?.calories = int.parse(_calories.value!);
          (allAerobicExercises[i])[0]?.duration[0] = _duration.value;
          (allAerobicExercises[i])[0]?.rateOfPerceivedExertion[0] =
              int.parse(_rateOfPerceivedExertion.value);
          _aerobicTrainingList.sink.add(allAerobicExercises);
          break;
        }
      }
    } else {
      List<Map<int, StrengthTraining>> allStrengthExercises =
          _strengthTrainingList.value;

      for (int i = 0; i < allStrengthExercises.length; i++) {
        if ((allStrengthExercises[i])[0]?.sequence == sequence) {
          (allStrengthExercises[i])[0]?.targetReps[_currentSet.value] =
              int.parse(_reps.value!);
          (allStrengthExercises[i])[0]?.targetWeights[_currentSet.value] =
              double.parse(_weight.value!);
          (allStrengthExercises[i])[0]
                  ?.rateOfPerceivedExertion[_currentSet.value] =
              int.parse(_rateOfPerceivedExertion.value);
          _strengthTrainingList.sink.add(allStrengthExercises);
          break;
        }
      }

      // // I'm assuming _strengthTrainingList is in .sequence order but it is not
      // (allAerobicExercises[sequence])[0]?.targetReps[_currentSet.value] =
      //     int.parse(_reps.value);
      // (allAerobicExercises[sequence])[0]?.targetWeights[_currentSet.value] =
      //     double.parse(_weight.value);
      // _strengthTrainingList.sink.add(allAerobicExercises);
    }
  }

  Future<void> saveJournal() async {
    List<Map<int, StrengthTraining>> strengthList = _strengthTrainingList.value;
    AWorkout aWorkout = _currentWorkout.value;
    double volume = 0;

    List<Map<String, StrengthTraining>> tempStrengthList = [];

    for (int i = 0; i < strengthList.length; i++) {
      // Store the all updates in one variable to later pass to the master
      Map<String, StrengthTraining> tempMap = {};

      // loop through each substitute exercise
      strengthList[i].forEach(
        (subSequencePos, exercise) {
          if (exercise.subSequence == 0) {
            for (int k = 0; k < exercise.targetWeights.length; k++) {
              volume += exercise.targetWeights[k] * exercise.targetReps[k];
            }
          }

          // (if) _strengthTrainingList[i] has more sets than _aWorkout.strengthExercises[i], only use values from _strengthTrainingList[i]
          if (exercise.sets >
              ((aWorkout.strengthExercises[i])['$subSequencePos']?.sets ?? 0)) {
            tempMap[subSequencePos.toString()] = exercise;
          }
          // (if) number of sets are equal (it can't be less as its not possible to remove sets)
          else {
            //changed double to num, as casting an integer was from firebase to double was not working correctly and instead kept throwing the error 'int is not a subtype of double', since int and double inherit from num I just changed it to num instead
            List<double> actualWeights = [];
            List<int> actualReps = [];
            // go through each entry and use strengthExercises[i] if value is present or else use value from _aWorkout.strengthExercises[i]
            for (int j = 0; j < exercise.targetWeights.length; j++) {
              // if input not zero then update reps and weight
              if (exercise.targetWeights[j] == 0 &&
                  exercise.targetReps[j] == 0) {
                actualWeights.add(
                  (aWorkout.strengthExercises[i])['$subSequencePos']
                          ?.targetWeights[j] ??
                      0,
                );
                actualReps.add(
                  (aWorkout.strengthExercises[i])['$subSequencePos']
                          ?.targetReps[j] ??
                      0,
                );
              } else {
                actualWeights.add(exercise.targetWeights[j]);
                actualReps.add(exercise.targetReps[j]);
              }
            }
            exercise.targetWeights = actualWeights;
            exercise.targetReps = actualReps;
            tempMap[subSequencePos.toString()] = exercise;
          }
        },
      );
      tempStrengthList.add(tempMap);
    }
    aWorkout.strengthExercises = tempStrengthList;

    List<Map<int, AerobicTraining>> aerobicList = _aerobicTrainingList.value;
    List<Map<String, AerobicTraining>> tempAerobicList = [];

    for (int i = 0; i < aerobicList.length; i++) {
      // Store the all updates in one variable to later pass to the master
      Map<String, AerobicTraining> tempAerobicMap = {};

      // loop through each substitute exercise
      aerobicList[i].forEach(
        (subSequence, exercise) {
          int actualDistance = 0;
          int actualDuration = 0;
          int actualCalories = 0;
          // if input not zero then update reps and weight
          if (exercise.distance[0] == 0 &&
              exercise.duration[0] == 0 &&
              exercise.calories == 0) {
            actualDistance =
                (aWorkout.aerobicExercises[i])['$subSequence']?.distance[0] ??
                    0;
            actualDuration =
                (aWorkout.aerobicExercises[i])['$subSequence']?.duration[0] ??
                    0;
            actualCalories =
                (aWorkout.aerobicExercises[i])['$subSequence']?.calories ?? 0;
          } else {
            actualDistance = exercise.distance[0];
            actualDuration = exercise.duration[0];
            actualCalories = exercise.calories;
          }

          exercise.distance[0] = actualDistance;
          exercise.duration[0] = actualDuration;
          exercise.calories = actualCalories;
          tempAerobicMap[subSequence.toString()] = exercise;
        },
      );
      tempAerobicList.add(tempAerobicMap);
    }
    aWorkout.aerobicExercises = tempAerobicList;

    aWorkout.workoutNote = _currentWorkoutNote.value;

    _totalVolume.sink.add(volume);

    return db
        .setWorkout(aWorkout)
        .then((value) => _aWorkoutSaved.sink.add(true))
        .catchError((error) => _aWorkoutSaved.sink.add(false));
  }

  void saveSubstitute(
    dynamic newSubstituteSequence, {
    int oldSubSequencePos = 0,
  }) {
    // Placeholder
    AWorkout aWorkout = _currentWorkout.value;

    // If the substitute we are adding is a strength exercise do the following
    if (newSubstituteSequence['0'].runtimeType == StrengthTraining) {
      // Placeholders
      Map<int, StrengthTraining> updatedActualExercises = {};
      Map<String, StrengthTraining> updatedTargetExercises = {};

      // Go through each key value pair in the substitute sequence
      newSubstituteSequence.forEach((key, aOldExercise) {
        StrengthTraining aExercise = aOldExercise as StrengthTraining;
        // copy primitive data types into a new object to prevent passing objects by reference
        StrengthTraining targetStrengthExercise = StrengthTraining(
          strengthExerciseName: aExercise.strengthExerciseName,
          sequence: aExercise.sequence,
          subSequence: aExercise.subSequence,
          exerciseType: aExercise.exerciseType,
          trainingType: aExercise.trainingType,
          sets: aExercise.sets,
          targetReps: aExercise.targetReps,
          targetWeights: aExercise.targetWeights,
          time: aExercise.time,
          enableTime: aExercise.enableTime,
          rateOfPerceivedExertion: aExercise.rateOfPerceivedExertion,
          enableRPE: aExercise.enableRPE,
          note: aExercise.note,
        );

        StrengthTraining actualStrengthExercise = StrengthTraining(
          strengthExerciseName: aExercise.strengthExerciseName,
          sets: aExercise.sets,
          sequence: aExercise.sequence,
          exerciseType: aExercise.exerciseType,
          trainingType: aExercise.trainingType,
          targetReps: List<int>.filled(aExercise.sets, 0),
          targetWeights: List<double>.filled(aExercise.sets, 0),
          time: aExercise.time,
          enableTime: aExercise.enableTime,
          rateOfPerceivedExertion: aExercise.rateOfPerceivedExertion,
          enableRPE: aExercise.enableRPE,
          subSequence: aExercise.subSequence,
          note: '',
        );

        //make the exercise the user selected the new primary
        if (aExercise.subSequence == oldSubSequencePos) {
          actualStrengthExercise.subSequence = 0;
          updatedActualExercises[0] = actualStrengthExercise;
          updatedTargetExercises['0'] = targetStrengthExercise;
        }
        //relegate the old primary
        else if (aExercise.subSequence == 0) {
          actualStrengthExercise.subSequence = oldSubSequencePos;
          updatedActualExercises[oldSubSequencePos] = actualStrengthExercise;
          updatedTargetExercises['$oldSubSequencePos'] = targetStrengthExercise;
        }
        // keep the remaining exercises in their current position
        else {
          updatedActualExercises[aExercise.subSequence] =
              actualStrengthExercise;
          updatedTargetExercises['${aExercise.subSequence}'] =
              targetStrengthExercise;
        }
      });

      // Update target (_aWorkout) and actual (_strengthTrainingList)
      final List<Map<int, StrengthTraining>> tempVar =
          _strengthTrainingList.value;
      for (int i = 0; i < tempVar.length; i++) {
        if ((tempVar[i])[0]?.sequence == newSubstituteSequence['0'].sequence) {
          tempVar[i] = updatedActualExercises;
          break;
        }
      }
      _strengthTrainingList.sink.add(tempVar);

      for (int i = 0; i < aWorkout.strengthExercises.length; i++) {
        if ((aWorkout.strengthExercises[i])['0']?.sequence ==
            newSubstituteSequence['0'].sequence) {
          aWorkout.strengthExercises[i] = updatedTargetExercises;
          break;
        }
      }
    } else {
      // Placeholders
      Map<int, AerobicTraining> updatedActualExercises = {};
      Map<String, AerobicTraining> updatedTargetExercises = {};

      // Go through each key value pair in the substitute sequence
      newSubstituteSequence.forEach((key, aOldExercise) {
        AerobicTraining aExercise = aOldExercise as AerobicTraining;
        // copy primitive data types into a new object to prevent passing objects by reference
        AerobicTraining targetAerobicExercise = AerobicTraining(
          aerobicExerciseName: aExercise.aerobicExerciseName,
          sequence: aExercise.sequence,
          subSequence: aExercise.subSequence,
          trainingType: aExercise.trainingType,
          exerciseType: aExercise.exerciseType,
          intervals: aExercise.intervals,
          distance: aExercise.distance,
          enableDistance: true,
          duration: aExercise.duration,
          enableDuration: aExercise.enableDuration,
          calories: aExercise.calories,
          enableCalories: aExercise.enableCalories,
          rateOfPerceivedExertion: aExercise.rateOfPerceivedExertion,
          enableRPE: false,
          speed: aExercise.speed,
          enableSpeed: false,
          resistance: aExercise.resistance,
          enableResistance: false,
          heartRateZone: aExercise.heartRateZone,
          enableHeatRateZone: false,
          note: aExercise.note,
        );

        AerobicTraining actualAerobicExercise = AerobicTraining(
          aerobicExerciseName: aExercise.aerobicExerciseName,
          sequence: aExercise.sequence,
          subSequence: aExercise.subSequence,
          exerciseType: aExercise.exerciseType,
          trainingType: aExercise.trainingType,
          intervals: aExercise.intervals,
          distance: [0],
          enableDistance: true,
          duration: [0],
          enableDuration: aExercise.enableDuration,
          calories: aExercise.calories,
          enableCalories: aExercise.enableCalories,
          rateOfPerceivedExertion: aExercise.rateOfPerceivedExertion,
          enableRPE: false,
          speed: aExercise.speed,
          enableSpeed: false,
          resistance: aExercise.resistance,
          enableResistance: false,
          heartRateZone: aExercise.heartRateZone,
          enableHeatRateZone: false,
          note: aExercise.note,
        );

        //make the exercise the user selected the new primary
        if (aExercise.subSequence == oldSubSequencePos) {
          actualAerobicExercise.subSequence = 0;
          updatedActualExercises[0] = actualAerobicExercise;
          updatedTargetExercises['0'] = targetAerobicExercise;
        }
        //relegate the old primary
        else if (aExercise.subSequence == 0) {
          actualAerobicExercise.subSequence = oldSubSequencePos;
          updatedActualExercises[oldSubSequencePos] = actualAerobicExercise;
          updatedTargetExercises['$oldSubSequencePos'] = targetAerobicExercise;
        }
        // keep the remaining exercises in their current position
        else {
          updatedActualExercises[aExercise.subSequence] = actualAerobicExercise;
          updatedTargetExercises['${aExercise.subSequence}'] =
              targetAerobicExercise;
        }
      });

      // Update target (_aWorkout) and actual (_aerobicTrainingList)
      List<Map<int, AerobicTraining>> tempVar = _aerobicTrainingList.value;
      for (int i = 0; i < tempVar.length; i++) {
        if ((tempVar[i])[0]?.sequence == newSubstituteSequence['0'].sequence) {
          tempVar[i] = updatedActualExercises;
          break;
        }
      }
      _aerobicTrainingList.sink.add(tempVar);

      for (int i = 0; i < aWorkout.aerobicExercises.length; i++) {
        if ((aWorkout.aerobicExercises[i])['0']?.sequence ==
            newSubstituteSequence['0'].sequence) {
          aWorkout.aerobicExercises[i] = updatedTargetExercises;
          break;
        }
      }
    }

    _currentWorkout.sink.add(aWorkout);
    _substituteSaved.sink.add(true);
  }

  void saveExerciseNote(int sequence, String note) {
    for (int i = 0; i < _strengthTrainingList.value.length; i++) {
      if ((_strengthTrainingList.value[i])[0]?.sequence == sequence) {
        List<Map<int, StrengthTraining>> strengthTrainingPlaceholder =
            _strengthTrainingList.value;
        (strengthTrainingPlaceholder[i])[0]?.note = note;
        _strengthTrainingList.sink.add(strengthTrainingPlaceholder);
        break;
      }
    }
    for (int i = 0; i < _aerobicTrainingList.value.length; i++) {
      if ((_aerobicTrainingList.value[i])[0]?.sequence == sequence) {
        List<Map<int, AerobicTraining>> aerobicTrainingListPlaceholder =
            _aerobicTrainingList.value;
        (aerobicTrainingListPlaceholder[i])[0]?.note = note;
        _aerobicTrainingList.sink.add(aerobicTrainingListPlaceholder);
        break;
      }
    }
  }

  //**************************************************************************\\
  //***************************** destructors ********************************\\
  //**************************************************************************\\

  void nullifyInputs() {
    _reps.sink.add(null);
    _currentSet.sink.add(0);
    _weight.sink.add(null);
    _distance.sink.add(null);
    _enableDuration.sink.add(false);
    _duration.sink.add(0);
    _currentExerciseName.sink.add('Journal Entry');
    _rateOfPerceivedExertion.sink.add('5');
    _enableRPE.sink.add(false);
    _enableCalories.sink.add(false);
    _calories.sink.add(null);
  }

  void dispose() {
    _currentWorkout.close();
    _aWorkoutName.close();
    _aerobicTrainingList.close();
    _strengthTrainingList.close();
    _duration.close();
    _enableDuration.close();
    _distance.close();
    _weight.close();
    _reps.close();
    _aWorkoutSaved.close();
    _substituteSaved.close();
    _currentSet.close();
    _currentExerciseName.close();
    _enableRPE.close();
  }
}
