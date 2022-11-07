import 'dart:async';

import 'package:exercise_journal/src/models/workout_planning_template/a_workout.dart';
import 'package:exercise_journal/src/models/workout_planning_template/aerobic_training.dart';
import 'package:exercise_journal/src/models/workout_planning_template/strength_training.dart';
import 'package:exercise_journal/src/services/firestore_workouts_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class WorkoutPlanBloc {
  //****************** reference to top level collection *********************\\
  final db = ProgrammesRepository();

  //***************************** Cache values ********************************\\
  // Behaviour subjects remember their last value, useful for allowing memory persistence
  final _workout = BehaviorSubject<AWorkout>();
  final _userID = BehaviorSubject<String>();
  final _substituteSequence = BehaviorSubject<Map<String, dynamic>>();
  Uuid uuid = const Uuid();

  //*********************** Edit Exercise Parameters **************************\\
  final _workoutType = BehaviorSubject<String>();
  final _exerciseName = BehaviorSubject<String?>();
  final _exerciseSets = BehaviorSubject<int>();
  final _exerciseType = BehaviorSubject<String>();
  final _exerciseDistance = BehaviorSubject<String?>();
  final _exerciseDuration = BehaviorSubject<int>();
  final _trainingType = BehaviorSubject<String>();
  final _workoutName = BehaviorSubject<String?>();
  final _activeDays = BehaviorSubject<List<bool>>();
  final _archive = BehaviorSubject<bool>();
  final _enableDuration = BehaviorSubject<bool>();
  final _enableRPE = BehaviorSubject<bool>();
  final _enableCalories = BehaviorSubject<bool>();
  final _calories = BehaviorSubject<String?>();

  //****************************** Notifiers *********************************\\
  //publish subject does not save last value once used its goes back to being blank
  final _workoutSaved = PublishSubject<bool>();
  final _workoutDeleted = PublishSubject<bool>();

  //**************************************************************************\\
  //******************************* Getters **********************************\\
  //**************************************************************************\\
  Stream<String?> get workoutName =>
      _workoutName.stream.transform(validateWorkoutName);

  Stream<List<bool>> get activeDays => _activeDays.stream;

  Stream<bool> get isValid => CombineLatestStream.combine2(
        workoutName,
        activeDays,
        (name, days) =>
            _workout.value.strengthExercises.isNotEmpty ||
            _workout.value.aerobicExercises.isNotEmpty,
      );

  // This function is called in the homepage and its results is stored in a List<AWorkout> value provided
  Stream<List<AWorkout>> getAllWorkouts(String userId) {
    return db.getWorkoutPrograms(userId);
  }

  Stream<bool> get workoutSaved => _workoutSaved.stream;

  Stream<bool> get workoutDeleted => _workoutDeleted.stream;

  // getAWorkout() used when adding or editing a workout
  Future<AWorkout> getAWorkout(String userID, String workoutID) {
    if (workoutID == '') {
      final Future<AWorkout> emptyWorkout = AWorkout(
        workoutName: '',
        strengthExercises: [],
        aerobicExercises: [],
        activeDays: [],
        workoutID: '',
        userID: '',
        workoutNote: '',
        workoutDuration: 0,
      ) as Future<AWorkout>;
      return emptyWorkout;
    }
    return db.getAWorkout(userID, workoutID);
  }

  Stream<String> get workoutType => _workoutType.stream;

  Stream<bool> get archive => _archive.stream;

  Stream<String> get exerciseName =>
      _exerciseName.stream.transform(validateExerciseName);

  Stream<int> get exerciseSets => _exerciseSets.stream;

  Stream<String> get exerciseType => _exerciseType.stream;

  Stream<int> get exerciseDistance =>
      _exerciseDistance.stream.transform(validateDistance);

  Stream<int> get exerciseDuration => _exerciseDuration.stream;

  Stream<String> get trainingType => _trainingType.stream;

  //Change this into a List instead of map since the primary exercises are already order and just need to be printed
  Stream<Map<int, dynamic>> get orderedPrimaryExercises =>
      _workout.stream.transform(orderPrimaryExercises);

  Stream<Map<String, dynamic>> get substituteExercises =>
      _substituteSequence.stream;

  Stream<bool> get enableDuration => _enableDuration.stream;

  Stream<bool> get enableRPE => _enableRPE.stream;

  Stream<bool> get enableCalories => _enableCalories.stream;

  Stream<int> get calories => _calories.stream.transform(validateCalories);

  //Changed aerobic validity check
  Stream<bool> get isAerobicValid => CombineLatestStream.combine2(
        exerciseType,
        exerciseName,
        (type, name) => true,
      );

  // Stream<bool> get isAerobicValid => CombineLatestStream.combine4(
  //     exerciseType,
  //     exerciseName,
  //     exerciseDistance,
  //     exerciseDuration,
  //     (type, name, distance, duration) => true);

  Stream<bool> get isStrengthValid => CombineLatestStream.combine3(
        exerciseType,
        exerciseName,
        exerciseSets,
        (type, name, sets) => true,
      );

  //**************************************************************************\\
  //******************************* Setters **********************************\\
  //**************************************************************************\\

  Function(String) get changeWorkoutName => _workoutName.sink.add;

  Function(List<bool>) get changeActiveDays => _activeDays.sink.add;

  Function(String) get changeUserID => _userID.sink.add;

  Function(String) get changeWorkoutSaved => _userID.sink.add;

  Function(String) get changeWorkoutType => _workoutType.add;

  Function(bool) get changeArchive => _archive.add;

  Function(String) get changeExerciseName => _exerciseName.sink.add;

  Function(int) get changeExerciseSets => _exerciseSets.sink.add;

  Function(String) get changeExerciseType => _exerciseType.sink.add;

  Function(String) get changeExerciseDistance => _exerciseDistance.sink.add;

  Function(int) get changeExerciseDuration => _exerciseDuration.sink.add;

  Function(String) get changeSetType => _trainingType.sink.add;

  Function(bool) get changeEnableDuration => _enableDuration.add;

  Function(bool) get changeEnableRPE => _enableRPE.add;

  Function(bool) get changeEnableCalories => _enableCalories.add;

  Function(String) get changeExerciseCalories => _calories.sink.add;

  //**************************************************************************\\
  //****************************** Validators *********************************\\
  //**************************************************************************\\
  final validateWorkoutName = StreamTransformer<String?, String>.fromHandlers(
    handleData: (workoutName, sink) {
      if (workoutName == null) {
        sink.add('');
      } else {
        if (workoutName != '' && workoutName.length <= 25) {
          sink.add(workoutName);
        } else if (workoutName.length > 25) {
          sink.addError('25 characters maximum');
        } else if (workoutName == '') {
          sink.addError('Workout name can not be empty');
        }
      }
    },
  );

  final validateExerciseName = StreamTransformer<String?, String>.fromHandlers(
    handleData: (exerciseName, sink) {
      if (exerciseName == null) {
        sink.add('');
      } else if (exerciseName.isNotEmpty && exerciseName.length <= 30) {
        sink.add(exerciseName);
      } else if (exerciseName.length > 30) {
        sink.addError('30 characters maximum');
      } else if (exerciseName == '') {
        sink.addError('Exercise name can not be empty');
      }
    },
  );

  final validateDistance = StreamTransformer<String?, int>.fromHandlers(
    handleData: (exerciseDistance, sink) {
      if (exerciseDistance == null) {
        sink.add(0);
      } else if (exerciseDistance == '' || exerciseDistance == '0') {
        sink.addError('Distance can not be empty');
      } else {
        try {
          if (int.parse(exerciseDistance) > 99999) {
            sink.addError('Distance cant be greater than 99999');
          } else {
            sink.add(int.parse(exerciseDistance));
          }
        } catch (error) {
          sink.addError('Distance must be a whole number');
        }
      }
    },
  );

  final validateCalories = StreamTransformer<String?, int>.fromHandlers(
    handleData: (calories, sink) {
      if (calories != null) {
        try {
          if (calories == '' || calories == '0') {
            sink.addError('Calories can not be empty');
          }
          if (int.parse(calories) > 9999) {
            sink.addError('Calories cant be greater than 9999');
          } else {
            sink.add(int.parse(calories));
          }
        } catch (error) {
          sink.addError('Calories must be a whole number');
        }
      }
    },
  );

  //**************************************************************************\\
  //****************************** Functions *********************************\\
  //**************************************************************************\\

  //********************************** setup **********************************\\
//  Function(AWorkout) get changeWorkout => _workout.sink.add;
  void loadWorkout(AWorkout workout) {
    //Will this condition ever be triggered?
    if (workout.workoutName == '') {
      _workout.sink.add(
        AWorkout(
          workoutName: '',
          strengthExercises: <Map<String, StrengthTraining>>[],
          aerobicExercises: <Map<String, AerobicTraining>>[],
          userID: '',
          activeDays: List<bool>.generate(7, (int index) => false),
          workoutID: '',
          workoutNote: '',
          workoutDuration: 0,
        ),
      );
      nullifyAll();
    } else {
      // Would it be more efficient to initialise all fields related to a workout here?
      // As changes will eventually be done after this function has been call
      // So it is more efficient just to do it all in one go and then not need to worry
      // about calling it after this function has been called
      _workout.sink.add(workout);
      _workoutName.sink.add(workout.workoutName);
      _activeDays.sink.add(workout.activeDays);
    }
  }

  void setUpExerciseForEditing(dynamic exercise) {
    if (exercise is StrengthTraining) {
      final StrengthTraining strengthTraining = exercise;
      _workoutType.sink.add('Strength Training');
      _exerciseType.sink.add(strengthTraining.exerciseType);
      _exerciseName.sink.add(strengthTraining.strengthExerciseName);
      _exerciseSets.sink.add(strengthTraining.sets);
      _enableRPE.sink.add(strengthTraining.enableRPE);
    } else {
      final AerobicTraining aerobicTraining = exercise as AerobicTraining;
      _workoutType.sink.add('Aerobic Training');
      _exerciseType.sink.add(aerobicTraining.exerciseType);
      _exerciseName.sink.add(aerobicTraining.aerobicExerciseName);
      _exerciseDistance.sink.add(aerobicTraining.distance[0].toString());
      _exerciseDuration.sink.add(aerobicTraining.duration[0]);
      _enableDuration.sink.add(aerobicTraining.enableDuration);
      _enableRPE.sink.add(aerobicTraining.enableRPE);
      _enableCalories.sink.add(aerobicTraining.enableCalories);
      _calories.sink.add(aerobicTraining.calories.toString());
    }
  }

  void setUpSubstituteExercises(int sequence) {
    Map<String, dynamic> substituteExercises = {};
    final List<List<Map<String, dynamic>>> workoutByType = [
      _workout.value.strengthExercises,
      _workout.value.aerobicExercises,
    ];

    for (final exerciseList in workoutByType) {
      for (final substituteExercisesMap in exerciseList) {
        if (substituteExercisesMap['0'].sequence == sequence) {
          substituteExercises.addAll(substituteExercisesMap);
        }
      }
    }

    if (substituteExercises['0'].runtimeType == StrengthTraining) {
      _substituteSequence.sink.add(substituteExercises);
      _workoutType.sink.add('Strength Training');
      _exerciseType.sink.add((substituteExercises['0']).exerciseType as String);
      _exerciseSets.sink.add((substituteExercises['0']).sets as int);
      _enableRPE.sink.add((substituteExercises['0']).enableRPE as bool);
    } else {
      _substituteSequence.sink.add(substituteExercises);
      _workoutType.sink.add('Aerobic Training');
      _exerciseType.sink.add((substituteExercises['0']).exerciseType as String);
      _enableDuration.sink
          .add((substituteExercises['0']).enableDuration as bool);
      _enableRPE.sink.add((substituteExercises['0']).enableRPE as bool);
      _enableCalories.sink
          .add((substituteExercises['0']).enableCalories as bool);
    }
  }

  // This function is the exact same as in the journaling_bloc
  final orderPrimaryExercises =
      StreamTransformer<AWorkout, Map<int, dynamic>>.fromHandlers(
    handleData: (workout, sink) {
      // if exercises have been added then order them by sequence
      // if (workout.strengthExercises != <StrengthTraining>[] ||
      //     workout.aerobicExercises != <AerobicTraining>[]) {
      //   Map<int, dynamic> sequenceOfExercise = {};
      //   //put exercises into a list
      //   List workoutByType = [
      //     workout.strengthExercises,
      //     workout.aerobicExercises
      //   ];
      //   for (var exerciseList in workoutByType) {
      //     if (exerciseList != null) {
      //       //Will this happen, Can workout.strengthExercises or workout.aerobicExercises ever be null?
      //       // for(int i = 0; i < exerciseList.length; i++){
      //       //   print('exerciseList[$i].sequence: ${exerciseList[i].sequence}');
      //       //   sequenceOfExercise[exerciseList[i].sequence] = exerciseList[i];
      //       // }
      //
      //       //For each exercises in workout.strengthExercises and workout.aerobicExercises, put them into a ordered map
      //       exerciseList.forEach((exercise) {
      //         sequenceOfExercise[exercise.sequence] = exercise;
      //       });
      //     }
      //   }
      //   sink.add(sequenceOfExercise);
      // }

      // 1. Create a Map to store all exercises
      Map<int, dynamic> sequenceOfExercise = <int, dynamic>{};
      // 2. Get all exercises into one list
      // List<dynamic> listOfAllExerciseTypes = workout.strengthExercises;
      List<dynamic> listOfAllExerciseTypes =
          List.from(workout.strengthExercises)
            ..addAll(workout.aerobicExercises);

      // 3. Add all exercises the Map
      for (final mapOfAllExercises in listOfAllExerciseTypes) {
        sequenceOfExercise[mapOfAllExercises['0'].sequence as int] =
            mapOfAllExercises['0'];
        // When I implement aerobic exercises I will have to use the below code
        // mapOfAllExercises.forEach((k, v) => print("Key : $k, Value : $v"));
        // for(var exercise in mapOfAllExercises){
        //   sequenceOfExercise[exercise['0'].sequence] = exercise['0'];
        // }
      }

      // 4. Get all the keys for the Map and sort them
      final sortedKeys = sequenceOfExercise.keys.toList()..sort();

      // 5. retrieve data via sorted keys
      // and return add all sorted keys to a separate map
      Map<int, dynamic> orderedSequenceOfExercise = <int, dynamic>{};
      for (final int key in sortedKeys) {
        orderedSequenceOfExercise[key] = sequenceOfExercise[key];
      }
      // Return the first item in the each position of the dict
      // Add each item to the dictionary
      //
      // var newList = List.from(workout.strengthExercises)
      //   ..addAll(workout.aerobicExercises);
      //
      // for (var exercise in newList) {
      //   if (exercise.subSequence != 0) {
      //     continue;
      //   }
      //   sequenceOfExercise[exercise.sequence] = exercise;
      // }

      //return a Map<> containing only one value
      sink.add(orderedSequenceOfExercise);
    },
  );

  void reorder({required int oldIdx, required int newIdx}) {
    AWorkout workoutToUpdate = _workout.value;

    // Make a list to hold the current sequence positions
    List<int> sequences = <int>[];
    for (final element in workoutToUpdate.strengthExercises) {
      sequences.add(element['0']?.sequence ?? 0);
    }
    for (final element in workoutToUpdate.aerobicExercises) {
      sequences.add(element['0']?.sequence ?? 0);
    }

    // Making sure the sequence is in order
    sequences.sort();

    // swap sequence positions
    final int sequenceHolder =
        sequences[oldIdx]; // create a copy of the old exercise
    sequences.removeAt(oldIdx); // remove the old index
    int newIndex = newIdx;
    if (newIdx > oldIdx) {
      // If moving from a lower to higher position -1 from new index position
      newIndex -= 1;
    }
    sequences.insert(
      newIndex,
      sequenceHolder,
    ); //insert exercise at new index pos

    // Make a hashmap of the current position as key and new position as value
    Map<int, int> hashMap = <int, int>{};
    for (int i = 0; i < sequences.length; i++) {
      hashMap[sequences[i]] = i;
    }

    // Go through each exercises updating the sequence position
    for (int i = 0; i < workoutToUpdate.strengthExercises.length; i++) {
      workoutToUpdate.strengthExercises[i]
          .forEach((subSequencePos, aSubstituteExercise) {
        aSubstituteExercise.sequence =
            hashMap[aSubstituteExercise.sequence] ?? 0;
      });
      // (workoutToUpdate.strengthExercises[i])['0']?.sequence =
      //     hashMap[(workoutToUpdate.strengthExercises[i])['0']?.sequence] ?? 0;
    }
    for (int i = 0; i < workoutToUpdate.aerobicExercises.length; i++) {
      workoutToUpdate.aerobicExercises[i]
          .forEach((subSequencePos, aSubstituteExercise) {
        aSubstituteExercise.sequence =
            hashMap[aSubstituteExercise.sequence] ?? 0;
      });
    }

    _workout.sink.add(workoutToUpdate);
  }

  Future<void> saveWorkout() async {
    final AWorkout currentWorkout = _workout.value;

    final workout = AWorkout(
      workoutName: _workoutName.value?.trim() ?? '',
      activeDays: _activeDays.value,
      userID: _userID.value,
      workoutID: (currentWorkout.workoutID == '')
          ? uuid.v4()
          : currentWorkout.workoutID,
      strengthExercises: (currentWorkout.strengthExercises == [])
          ? []
          : currentWorkout.strengthExercises,
      aerobicExercises: (currentWorkout.aerobicExercises == [])
          ? []
          : currentWorkout.aerobicExercises,
      archive: _archive.hasValue ? _archive.value : false,
      //archive property is not being updated in the stream. When will this property be used in the app as I have not enabled archiving anywhere
      workoutNote: currentWorkout.workoutNote,
      workoutDuration: currentWorkout.workoutDuration,
    );

    return db
        .setWorkout(workout)
        .then((value) => _workoutSaved.sink.add(true))
        .catchError((error) => _workoutSaved.sink.add(false));
  }

  void deleteExercise(var exerciseToDelete) {
    // I can just go ahead and delete in the master copy since unless it is saved it will be updated from the cloud
    AWorkout workout = _workout.value;
    // Search workout to find the correct exercise sequence and remove it
    if (exerciseToDelete is StrengthTraining) {
      for (int i = 0; i < workout.strengthExercises.length; i++) {
        if ((workout.strengthExercises[i])['0']?.sequence ==
            exerciseToDelete.sequence) {
          workout.strengthExercises.removeAt(i);
          break;
        }
      }
    } else if (exerciseToDelete is AerobicTraining) {
      for (int i = 0; i < workout.aerobicExercises.length; i++) {
        if ((workout.aerobicExercises[i])['0']?.sequence ==
            exerciseToDelete.sequence) {
          workout.aerobicExercises.removeAt(i);
          break;
        }
      }
    }

    //update exercise sequences
    final List workoutByType = [
      workout.strengthExercises,
      workout.aerobicExercises
    ];
    for (final element in workoutByType) {
      element.forEach((aExercise) {
        if ((aExercise['0'].sequence > exerciseToDelete.sequence) as bool) {
          // aExercise['0'].sequence -= 1;
          aExercise.forEach((key, exercise) {
            exercise.sequence -= 1;
          });
        }
      });
    }

    //What is this for, I'm already doing the re-ordering. why am I doing it again???
    // List<int> listOsSequenceValues = <int>[];
    //
    // for (var element in workout.strengthExercises) {
    //   listOsSequenceValues.add(element['0']?.sequence ?? 0);
    // }
    // // for (var element in workout.aerobicExercises) {
    // //   listOsSequenceValues.add(element.sequence);
    // // }
    // listOsSequenceValues.sort();
    // Map<int, int> hashMap = <int, int>{};
    // for (int i = 0; i < listOsSequenceValues.length; i++) {
    //   hashMap[i] = listOsSequenceValues[i];
    // }
    // for (var element in workout.strengthExercises) {
    //   int sequence = element['0']?.sequence ?? 0;
    //   element['0']?.sequence = hashMap[sequence]!.toInt();
    // }
    // // for (var element in workout.aerobicExercises) {
    // //   int sequence = element.sequence;
    // //   element.sequence = hashMap[sequence]!.toInt();
    // // }

    _workout.sink.add(workout);
  }

  dynamic deleteWorkout(AWorkout workout) {
    return db
        .deleteData(workout)
        .then((value) => _workoutDeleted.sink.add(true))
        .catchError((error) => _workoutDeleted.sink.add(false));
  }

  //******************************** Modifiers ********************************\\
  void addStrengthExercise({
    required int sequencePosition,
    required int subSequencePosition,
  }) {
    // Set up an object of StrengthTraining
    final StrengthTraining addExercise = StrengthTraining(
      strengthExerciseName: _exerciseName.value?.trim() ?? '',
      sequence: sequencePosition == -1 ? sequencePos : sequencePosition,
      subSequence: subSequencePosition == -1
          ? _subSequencePos(sequencePosition)
          : subSequencePosition,
      sets: _exerciseSets.value,
      exerciseType: _exerciseType.value == '' ? 'Workout' : _exerciseType.value,
      trainingType: '',
      targetReps: List<int>.filled(_exerciseSets.value, 0),
      targetWeights: List<double>.filled(_exerciseSets.value, 0),
      time: [0],
      enableTime: false,
      rateOfPerceivedExertion: List<int>.filled(_exerciseSets.value, 0),
      enableRPE: _enableRPE.hasValue ? _enableRPE.value : false,
      note: '',
    );

    const int firstExercise = -1;

    if (sequencePosition == firstExercise) {
      // if empty add first value
      // I can check if sub is not == -1 instead and this would mean less code
      _workout.value.strengthExercises
          .add({'${addExercise.subSequence}': addExercise});
      _workout.sink.add(_workout.value);
    } else if (subSequencePosition != -1) {
      // find exercise to be updated
      var workout = _workout.value.strengthExercises;
      for (int i = 0; i < workout.length; i++) {
        if ((workout[i])['0']?.sequence == sequencePosition) {
          (workout[i])['${addExercise.subSequence}'] = addExercise;
          //update master copy
          AWorkout updatedWorkout = _workout.value;
          updatedWorkout.strengthExercises = workout;
          _workout.sink.add(updatedWorkout);
          break;
        }
      }
    } else {
      // adding substitute exercises
      // go to the sequence pos and update the map of substitute exercises
      var substitutes = _substituteSequence.value;
      substitutes['${_subSequencePos(sequencePosition)}'] = addExercise;
      _substituteSequence.sink.add(substitutes);
    }
  }

  void addAerobicExercise({
    required int sequencePosition,
    required int subSequencePosition,
  }) {
    // Find what sequence position to set
    AerobicTraining addExercise = AerobicTraining(
      aerobicExerciseName: _exerciseName.value?.trim() ?? '',
      sequence: sequencePosition == -1 ? sequencePos : sequencePosition,
      subSequence: subSequencePosition == -1
          ? _subSequencePos(sequencePosition)
          : subSequencePosition,
      exerciseType: _exerciseType.value == '' ? 'Workout' : _exerciseType.value,
      trainingType: '',
      intervals: 0,
      enableDistance: true,
      distance: [
        if (_exerciseDistance.value == '')
          0
        else
          int.parse(_exerciseDistance.value ?? '0')
      ],
      enableDuration: _enableDuration.hasValue ? _enableDuration.value : false,
      duration: [_exerciseDuration.hasValue ? _exerciseDuration.value : 0],
      enableCalories: _enableCalories.hasValue ? _enableCalories.value : false,
      calories: _calories.hasValue ? int.parse(_calories.value ?? '0') : 0,
      enableHeatRateZone: false,
      heartRateZone: [0],
      enableResistance: false,
      resistance: [0],
      enableSpeed: false,
      speed: [0],
      enableRPE: _enableRPE.hasValue ? _enableRPE.value : false,
      rateOfPerceivedExertion: [0],
      note: '',
    );

    const int firstExercise = -1;

    if (sequencePosition == firstExercise) {
      // if empty add first value
      // I can check if sub is not == -1 instead and this would mean less code
      _workout.value.aerobicExercises
          .add({'${addExercise.subSequence}': addExercise});
      _workout.sink.add(_workout.value);
    } else if (subSequencePosition != -1) {
      // find exercise to be updated
      var workout = _workout.value.aerobicExercises;
      for (int i = 0; i < workout.length; i++) {
        if ((workout[i])['0']?.sequence == sequencePosition) {
          (workout[i])['${addExercise.subSequence}'] = addExercise;
          //update master copy
          AWorkout updatedWorkout = _workout.value;
          updatedWorkout.aerobicExercises = workout;
          _workout.sink.add(updatedWorkout);
          break;
        }
      }
    } else {
      // adding substitute exercises
      // go to the sequence pos and update the map of substitute exercises
      var substitutes = _substituteSequence.value;
      substitutes['${_subSequencePos(sequencePosition)}'] = addExercise;
      _substituteSequence.sink.add(substitutes);
    }
  }

  //**************************************************************************\\
  //************************* Supporting Functions ****************************\\
  //**************************************************************************\\
  int get sequencePos {
    final AWorkout currentWorkout = _workout.value;
    if (currentWorkout.strengthExercises.isEmpty &&
        currentWorkout.aerobicExercises.isEmpty) {
      return 0;
    }
    if (currentWorkout.strengthExercises != [] &&
        currentWorkout.aerobicExercises.isEmpty) {
      return currentWorkout.strengthExercises.length;
    }
    if (currentWorkout.strengthExercises.isEmpty &&
        currentWorkout.aerobicExercises != []) {
      return currentWorkout.aerobicExercises.length;
    } else {
      return currentWorkout.strengthExercises.length +
          currentWorkout.aerobicExercises.length;
    }
  }

// subSequencePos(int sequence) finds the index position for the substitute to be added to
  int _subSequencePos(int sequence) {
    int subSequence = 0;

    //if this is the first exercise in the sequence
    if (sequence == -1) {
      return 0;
    } else if (_substituteSequence.hasValue) {
      _substituteSequence.value.forEach((key, value) {
        if ((value.subSequence as int) >= subSequence) {
          subSequence = (value.subSequence as int) + 1;
        }
      });
    }
    // if (_workout.value.aerobicExercises.isNotEmpty) {
    //   for (var exerciseMap in _workout.value.aerobicExercises) {
    //     if (exerciseMap.containsKey(sequence.toString())) {
    //       exerciseMap.forEach((key, value) {
    //         if (value.subSequence >= subSequence){
    //           subSequence = value.subSequence + 1;
    //         }
    //       });
    //     }
    //   }
    // }
    return subSequence;
  }

  //**************************************************************************\\
  //***************************** destructors ********************************\\
  //**************************************************************************\\

  void nullifyAll() {
    _workoutName.sink.add(null);
    _activeDays.sink.add(List<bool>.generate(7, (int index) => false));
    _exerciseType.sink.add('Workout');
    _exerciseName.sink.add(null);
    _exerciseSets.sink.add(1);
    _exerciseDuration.sink.add(0);
    _exerciseDistance.sink.add(null);
    _workoutType.sink.add('');
  }

  void nullifyExercise() {
    _exerciseType.sink.add('Workout');
    _exerciseName.sink.add(null);
    _exerciseSets.sink.add(1);
    _exerciseDuration.sink.add(0);
    _exerciseDistance.sink.add(null);
    _workoutType.sink.add('');
    _enableDuration.sink.add(false);
    _enableRPE.sink.add(false);
    _enableCalories.sink.add(false);
    _calories.sink.add(null);
  }

  void dispose() {
    _workoutName.close();
    _activeDays.close();
    _userID.close();
    _workoutSaved.close();
    _workoutDeleted.close();
    _workout.close();
    _workoutType.close();
    _exerciseName.close();
    _exerciseSets.close();
    _exerciseType.close();
    _exerciseDistance.close();
    _exerciseDuration.close();
    _trainingType.close();
    _archive.close();
  }
}
