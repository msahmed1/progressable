import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/models/workout_planning_template/a_workout.dart';
import 'package:exercise_journal/src/models/workout_planning_template/aerobic_training.dart';
import 'package:exercise_journal/src/models/workout_planning_template/strength_training.dart';
import 'package:exercise_journal/src/styles/base.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/exercise_type_representation.dart';
import 'package:flutter/material.dart';

import '../blocs/format_time.dart';

class ViewExercises extends StatelessWidget {
  const ViewExercises({
    required this.workoutList,
    super.key,
  });

  final AWorkout workoutList;

  @override
  Widget build(BuildContext context) {
    Map<int, dynamic> sequenceOfWorkouts = {};

    final List workoutsByType = [
      workoutList.strengthExercises,
      workoutList.aerobicExercises
    ];

    for (var exerciseList in workoutsByType) {
      if (exerciseList != null) {
        exerciseList.forEach((element) {
          sequenceOfWorkouts[element['0'].sequence as int] = element['0'];
        });
      }
    }

    final sortedKeys = sequenceOfWorkouts.keys.toList()..sort();

    return Column(
      children: <Widget>[
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: sortedKeys.length,
          itemBuilder: (BuildContext context, int index) {
            final exerciseSequence = sequenceOfWorkouts[sortedKeys[index]];
            String title = '';
            String subtitle = '';
            String type = '';

            if (exerciseSequence is StrengthTraining) {
              title = exerciseSequence.strengthExerciseName;
              subtitle = 'Sets: ${exerciseSequence.sets}';
              type = exerciseSequence.exerciseType;
            } else if (exerciseSequence is AerobicTraining) {
              title = exerciseSequence.aerobicExerciseName;
              if (exerciseSequence.enableDistance) {
                subtitle = '${subtitle}Dist: ${exerciseSequence.distance[0]}m';
                if (exerciseSequence.enableDuration ||
                    exerciseSequence.enableCalories) {
                  subtitle = '$subtitle,';
                }
              }
              if (exerciseSequence.enableDuration) {
                subtitle =
                    '$subtitle Time: ${FormatTime().displayTime(exerciseSequence.duration[0])}';
                if (exerciseSequence.enableCalories) {
                  subtitle = '$subtitle,';
                }
              }
              if (exerciseSequence.enableCalories) {
                subtitle = '$subtitle Kal: ${exerciseSequence.calories}';
              }

              type = exerciseSequence.exerciseType;
            }

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColours.forground,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        boxShadow: BaseStyles.cardShadow,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: WorkoutTypeColorRepresentation(
                              exercise: exerciseSequence,
                              exerciseType: type,
                              key: UniqueKey(),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 2.0),
                                  child: AutoSizeText(
                                    title,
                                    style: TextStyles.cardTitle,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                AutoSizeText(
                                  subtitle,
                                  style: TextStyles.cardBody,
                                  maxLines: 1,
                                  minFontSize: 8.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
