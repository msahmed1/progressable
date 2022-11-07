class StrengthTraining {
  String strengthExerciseName; //TODO: change name to
  int sequence;
  int subSequence;
  String exerciseType = 'Workout';
  String trainingType;

  // Exercise specific variables
  List<double> targetWeights;
  List<int> targetReps;
  int sets;

  List<int> time; //AMRAP Time
  bool enableTime;

  List<int> rateOfPerceivedExertion;
  bool enableRPE;

  String note;

  StrengthTraining({
    required this.strengthExerciseName,
    required this.sequence,
    required this.subSequence,
    required this.exerciseType,
    required this.trainingType,
    required this.sets,
    required this.targetWeights,
    required this.targetReps,
    required this.time,
    required this.enableTime,
    required this.rateOfPerceivedExertion,
    required this.enableRPE,
    required this.note,
  });

  //factory constructor to create an exercise from JSON
  factory StrengthTraining.fromFireStore(Map<dynamic, dynamic> fireStore) =>
      _strengthTrainingFromFireStore(fireStore);

  //turn exercise into a map of key/value pares
  Map<String, dynamic> toMap() => _strengthTrainingToMap(this);

  @override
  String toString() => "StrengthTraining<$strengthExerciseName>";
}

//helper functions below

//turns a map of values from fireStore into a exercise class
StrengthTraining _strengthTrainingFromFireStore(
  Map<dynamic, dynamic> fireStore,
) {
  return StrengthTraining(
    strengthExerciseName: fireStore['strengthExerciseName'] as String,
    sequence: fireStore['sequence'] as int,
    subSequence: fireStore['subSequence'] as int,
    exerciseType: fireStore['workoutType'] as String,
    trainingType: fireStore['trainingType'] as String,
    sets: fireStore['sets'] as int,
    targetWeights: List<double>.from(fireStore['targetWeights'] as List),
    targetReps: List<int>.from(fireStore['targetReps'] as List),
    time: List<int>.from(fireStore['time'] as List),
    enableTime: fireStore['enableTime'] as bool,
    rateOfPerceivedExertion: fireStore['rateOfPerceivedExertion'] == null
        ? []
        : List<int>.from(fireStore['rateOfPerceivedExertion'] as List),
    enableRPE: fireStore['enableRPE'] as bool,
    note: fireStore['note'] as String,
  );
}

//converts the exercise class into a map of key/value pairs
Map<String, dynamic> _strengthTrainingToMap(StrengthTraining instance) =>
    <String, dynamic>{
      'strengthExerciseName': instance.strengthExerciseName,
      'sequence': instance.sequence,
      'subSequence': instance.subSequence,
      'workoutType': instance.exerciseType,
      'trainingType': instance.trainingType,
      'sets': instance.sets,
      'targetWeights': instance.targetWeights,
      'targetReps': instance.targetReps,
      'time': instance.time,
      'enableTime': instance.enableTime,
      'rateOfPerceivedExertion': instance.rateOfPerceivedExertion,
      'enableRPE': instance.enableRPE,
      'note': instance.note,
    };
