import 'package:exercise_journal/src/models/workout_planning_template/strength_training.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkoutTypeColorRepresentation extends StatelessWidget {
  final dynamic exercise;
  final String exerciseType;

  const WorkoutTypeColorRepresentation({
    this.exercise,
    required this.exerciseType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (exerciseType == 'Warm Up') {
      if (exercise is StrengthTraining) {
        return Icon(
          FontAwesomeIcons.dumbbell,
          color: AppColours.warmUp,
        );
      }
      return Icon(
        FontAwesomeIcons.personRunning,
        color: AppColours.warmUp,
      );
    } else if (exerciseType == 'Workout') {
      if (exercise is StrengthTraining) {
        return Icon(
          FontAwesomeIcons.dumbbell,
          color: AppColours.workout,
        );
      }
      return Icon(
        FontAwesomeIcons.personRunning,
        color: AppColours.workout,
      );
    } else {
      if (exercise is StrengthTraining) {
        return Icon(
          FontAwesomeIcons.dumbbell,
          color: AppColours.coolDown,
        );
      }
      return Icon(
        FontAwesomeIcons.personRunning,
        color: AppColours.coolDown,
      );
    }
  }
}
