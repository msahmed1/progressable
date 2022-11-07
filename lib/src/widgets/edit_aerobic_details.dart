import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/blocs/workout_planning_bloc.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/adaptive_swithch.dart';
import 'package:exercise_journal/src/widgets/app_textfield.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:exercise_journal/src/widgets/rounded_icon_button.dart';
import 'package:exercise_journal/src/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditAerobicTraining extends StatefulWidget {
  final bool isUpdate;
  final int sequencePos;
  final int subSequencePos;

  const EditAerobicTraining({
    super.key,
    required this.isUpdate,
    required this.sequencePos,
    required this.subSequencePos,
  });

  @override
  State<EditAerobicTraining> createState() => _EditAerobicTrainingState();
}

class _EditAerobicTrainingState extends State<EditAerobicTraining> {
  bool updateText = false;
  UnfocusDisposition disposition = UnfocusDisposition.scope;
  late Timer timer;
  final List<String> trainingType = [
    'Steady pace',
    'Intervals',
    'Splits',
    'Circuit',
  ];
  int distance = 0;

  @override
  Widget build(BuildContext context) {
    var planingBloc = Provider.of<WorkoutPlanBloc>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(
            child: Text(
              'Add aerobic training info',
              style: TextStyles.suggestion,
            ),
          ),
        ),
        StreamBuilder<String>(
          stream: planingBloc.exerciseName,
          builder: (context, snapshot) {
            return AppTextField(
              hintText: 'Exercise Name',
              isIOS: Platform.isIOS,
              errorText: snapshot.hasError ? snapshot.error.toString() : '',
              initialText: snapshot.hasData ? snapshot.data.toString() : '',
              onChanged: planingBloc.changeExerciseName,
            );
          },
        ),
        StreamBuilder<int>(
          stream: planingBloc.exerciseDistance,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Column(
                children: [
                  AutoSizeText(
                    'What is your target distance?',
                    style: TextStyles.suggestion,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RoundIconButton(
                        icon: FontAwesomeIcons.minus,
                        onPressed: () {
                          primaryFocus!.unfocus(disposition: disposition);
                          if (snapshot.hasData) {
                            if (snapshot.data! > 1) {
                              planingBloc.changeExerciseDistance(
                                '${snapshot.data! - 1}',
                              );
                            } else {
                              planingBloc.changeExerciseDistance('99999');
                            }
                          } else {
                            planingBloc.changeExerciseDistance('99999');
                          }
                          updateText = true;
                        },
                      ),
                      Expanded(
                        child: AppTextField(
                          isIOS: Platform.isIOS,
                          hintText: 'In meters',
                          initialText: snapshot.hasData
                              ? (snapshot.data == 0
                                  ? ''
                                  : snapshot.data.toString())
                              : '',
                          textInputType: TextInputType.number,
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : '',
                          onChanged: (String keyBoardEvent) {
                            planingBloc.changeExerciseDistance(keyBoardEvent);
                            updateText = false;
                          },
                          update: updateText,
                        ),
                      ),
                      RoundIconButton(
                        icon: FontAwesomeIcons.plus,
                        onPressed: () {
                          primaryFocus!.unfocus(disposition: disposition);
                          if (snapshot.hasData) {
                            if (snapshot.data! < 99999) {
                              planingBloc.changeExerciseDistance(
                                '${snapshot.data! + 1}',
                              );
                            } else {
                              planingBloc.changeExerciseDistance('1');
                            }
                          } else {
                            planingBloc.changeExerciseDistance('1');
                          }
                          updateText = true;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        StreamBuilder<bool>(
          stream: planingBloc.enableDuration,
          initialData: false,
          builder: (context, snapshot) {
            // if (snapshot.data == null) {
            //   print('in null state xxxxxxxxxxx');
            //   return Container();
            // }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'Record Duration?',
                        style: TextStyles.body,
                      ),
                      AdaptiveSwitch(
                        currentState: snapshot.data ?? false,
                        onChange: (value) =>
                            planingBloc.changeEnableDuration(value as bool),
                      ),
                    ],
                  ),
                ),
                if (snapshot.data == true)
                  StreamBuilder<int>(
                    stream: planingBloc.exerciseDuration,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return TimePicker(
                          title: 'Set your duration target?',
                          duration: snapshot.hasData ? snapshot.data! : 0,
                          isIOS: Platform.isIOS,
                          onChange: planingBloc.changeExerciseDuration,
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
                else
                  Container(),
              ],
            );
          },
        ),
        StreamBuilder<bool>(
          stream: planingBloc.enableCalories,
          initialData: false,
          builder: (context, snapshot) {
            // if (snapshot.data == null) {
            //   print('in null state xxxxxxxxxxx');
            //   return Container();
            // }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'Record Calories?',
                        style: TextStyles.body,
                      ),
                      AdaptiveSwitch(
                        currentState: snapshot.data ?? false,
                        onChange: (value) =>
                            planingBloc.changeEnableCalories(value as bool),
                      ),
                    ],
                  ),
                ),
                if (snapshot.data == true)
                  StreamBuilder<int>(
                    stream: planingBloc.calories,
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                primaryFocus!.unfocus(disposition: disposition);
                                if (snapshot.hasData) {
                                  if (snapshot.data! > 1) {
                                    planingBloc.changeExerciseCalories(
                                      '${snapshot.data! - 1}',
                                    );
                                  } else {
                                    planingBloc.changeExerciseCalories('9999');
                                  }
                                } else {
                                  planingBloc.changeExerciseCalories('9999');
                                }
                                updateText = true;
                              },
                            ),
                            Expanded(
                              child: AppTextField(
                                isIOS: Platform.isIOS,
                                hintText: 'Set calorie target?',
                                initialText: snapshot.hasData
                                    ? (snapshot.data == 0
                                        ? ''
                                        : snapshot.data.toString())
                                    : '',
                                textInputType: TextInputType.number,
                                errorText: snapshot.hasError
                                    ? snapshot.error.toString()
                                    : '',
                                onChanged: (String keyBoardEvent) {
                                  planingBloc
                                      .changeExerciseCalories(keyBoardEvent);
                                  updateText = false;
                                },
                                update: updateText,
                              ),
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                primaryFocus!.unfocus(disposition: disposition);
                                if (snapshot.hasData) {
                                  if (snapshot.data! < 9999) {
                                    planingBloc.changeExerciseCalories(
                                      '${snapshot.data! + 1}',
                                    );
                                  } else {
                                    planingBloc.changeExerciseCalories('1');
                                  }
                                } else {
                                  planingBloc.changeExerciseCalories('1');
                                }
                                updateText = true;
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )
                else
                  Container(),
              ],
            );
          },
        ),
        StreamBuilder<bool>(
          stream: planingBloc.enableRPE,
          initialData: false,
          builder: (context, snapshot) {
            // if (snapshot.data == null) {
            //   print('in null state xxxxxxxxxxx');
            //   return Container();
            // }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    'Record RPE?',
                    style: TextStyles.body,
                  ),
                  AdaptiveSwitch(
                    currentState: snapshot.data ?? false,
                    onChange: (value) =>
                        planingBloc.changeEnableRPE(value as bool),
                  ),
                ],
              ),
            );
          },
        ),
        StreamBuilder<bool>(
          stream: planingBloc.isAerobicValid,
          builder: (context, snapshot) {
            return AppButton(
              buttonText: widget.isUpdate ? 'Update' : 'Add',
              buttonType:
                  snapshot.hasData ? ButtonType.primary : ButtonType.disabled,
              onPressed: () {
                planingBloc.addAerobicExercise(
                  sequencePosition: widget.sequencePos,
                  subSequencePosition: widget.subSequencePos,
                );
                planingBloc.nullifyExercise();
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ],
    );
  }
}
