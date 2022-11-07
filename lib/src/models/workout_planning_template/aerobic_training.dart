class AerobicTraining {
  String aerobicExerciseName;
  int sequence;
  int subSequence;
  String exerciseType = 'Workout';
  String trainingType;

  // Exercise specific variables
  List<int> distance;
  bool enableDistance;

  List<int> duration;
  bool enableDuration;

  List<int> resistance;
  bool enableResistance;

  List<int> speed;
  bool enableSpeed;

  List<int> heartRateZone;
  bool enableHeatRateZone;

  int calories;
  bool enableCalories;

  int intervals; // similar to sets

  List<int> rateOfPerceivedExertion;
  bool enableRPE;

  String note;

  AerobicTraining({
    required this.aerobicExerciseName,
    required this.sequence,
    required this.subSequence,
    required this.exerciseType,
    required this.trainingType,
    required this.distance,
    required this.enableDistance,
    required this.duration,
    required this.enableDuration,
    required this.resistance,
    required this.enableResistance,
    required this.speed,
    required this.enableSpeed,
    required this.heartRateZone,
    required this.enableHeatRateZone,
    required this.calories,
    required this.enableCalories,
    required this.rateOfPerceivedExertion,
    required this.enableRPE,
    required this.intervals,
    required this.note,
  });

  //factory constructor to create an exercise from JSON
  factory AerobicTraining.fromFireStore(Map<dynamic, dynamic> firestore) =>
      _aerobicFromFirestore(firestore);

  //turn exercise into a map of key/value pares
  Map<String, dynamic> toMap() => _aerobicToMap(this);

  @override
  String toString() => "AerobicTraining<$aerobicExerciseName>";
}

//turns a map of values from firestore into a exercise class
AerobicTraining _aerobicFromFirestore(Map<dynamic, dynamic> fireStore) {
  return AerobicTraining(
    aerobicExerciseName: fireStore['aerobicName'] as String,
    sequence: fireStore['sequence'] as int,
    subSequence: fireStore['subSequence'] as int,
    exerciseType: fireStore['exerciseType'] as String,
    trainingType: fireStore['trainingType'] as String,
    intervals: fireStore['intervals'] as int,
    distance: List<int>.from(fireStore['distance'] as List),
    enableDistance: fireStore['enableDistance'] as bool,
    duration: List<int>.from(fireStore['duration'] as List),
    enableDuration: fireStore['enableDuration'] as bool,
    resistance: List<int>.from(fireStore['resistance'] as List),
    enableResistance: fireStore['enableResistance'] as bool,
    speed: List<int>.from(fireStore['speed'] as List),
    enableSpeed: fireStore['enableSpeed'] as bool,
    heartRateZone: List<int>.from(fireStore['hearRateZone'] as List),
    enableHeatRateZone: fireStore['enableHeatRateZone'] as bool,
    calories: fireStore['calories'] as int,
    enableCalories: fireStore['enableCalories'] as bool,
    rateOfPerceivedExertion:
        List<int>.from(fireStore['rateOfPerceivedExertion'] as List),
    enableRPE: fireStore['enableRPE'] as bool,
    note: fireStore['note'] as String,
  );
}

//converts the exercise class into a map of key/value pairs
Map<String, dynamic> _aerobicToMap(AerobicTraining instance) =>
    <String, dynamic>{
      'aerobicName': instance.aerobicExerciseName,
      'sequence': instance.sequence,
      'subSequence': instance.subSequence,
      'exerciseType': instance.exerciseType,
      'trainingType': instance.trainingType,
      'intervals': instance.intervals,
      'distance': instance.distance,
      'enableDistance': instance.enableDistance,
      'duration': instance.duration,
      'enableDuration': instance.enableDuration,
      'resistance': instance.resistance,
      'enableResistance': instance.enableResistance,
      'speed': instance.speed,
      'enableSpeed': instance.enableSpeed,
      'hearRateZone': instance.heartRateZone,
      'enableHeatRateZone': instance.enableHeatRateZone,
      'calories': instance.calories,
      'enableCalories': instance.enableCalories,
      'rateOfPerceivedExertion': instance.rateOfPerceivedExertion,
      'enableRPE': instance.enableRPE,
      'note': instance.note,
    };
