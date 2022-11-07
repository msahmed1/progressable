import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/blocs/workout_planning_bloc.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/app_textfield.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:exercise_journal/src/widgets/rounded_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'adaptive_swithch.dart';

class EditStrengthTraining extends StatefulWidget {
  //***************************** local variables *****************************\\

  final bool isUpdate;
  final int sequencePos;
  final int subSequencePos;

  //**************************************************************************\\
  //***************************** Constructor ********************************\\
  //**************************************************************************\\
  const EditStrengthTraining({
    super.key,
    required this.isUpdate,
    required this.sequencePos,
    required this.subSequencePos,
  });

  @override
  State<EditStrengthTraining> createState() => _EditStrengthTrainingState();
}

class _EditStrengthTrainingState extends State<EditStrengthTraining> {
  //***************************** local variables *****************************\\
  final List<String> trainingType = [
    'Straight Set',
    'Pyramid Set',
    'Drop Set',
    'Super Set'
  ];

  //**************************************************************************\\
  //*************************** build Function *******************************\\
  //**************************************************************************\\
  @override
  Widget build(BuildContext context) {
    WorkoutPlanBloc planingBloc = Provider.of<WorkoutPlanBloc>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(
            child: Text(
              'Add strength training info',
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
              onChanged: (name) {
                planingBloc.changeExerciseName(name);
              },
            );
          },
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Set',
              style: TextStyles.suggestion,
            ),
            StreamBuilder<int>(
              stream: planingBloc.exerciseSets,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundIconButton(
                      icon: FontAwesomeIcons.minus,
                      onPressed: () {
                        if (snapshot.data! > 1) {
                          planingBloc.changeExerciseSets(snapshot.data! - 1);
                        } else {
                          planingBloc.changeExerciseSets(20);
                        }
                      },
                    ),
                    Container(
                      width: 60.0,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        snapshot.data == null ? '1' : snapshot.data.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    RoundIconButton(
                      icon: FontAwesomeIcons.plus,
                      onPressed: () {
                        if (snapshot.data == null) {
                          planingBloc.changeExerciseSets(2);
                        } else if (snapshot.data! >= 20) {
                          planingBloc.changeExerciseSets(1);
                        } else {
                          planingBloc.changeExerciseSets(snapshot.data! + 1);
                        }
                      },
                    ),
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
          ],
        ),
        StreamBuilder<bool>(
          stream: planingBloc.isStrengthValid,
          builder: (context, snapshot) {
            return AppButton(
              buttonText: widget.isUpdate ? 'Update' : 'Add',
              buttonType: snapshot.data == true
                  ? ButtonType.primary
                  : ButtonType.disabled,
              onPressed: () {
                planingBloc.addStrengthExercise(
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

//**************************************************************************\\
//****************************** Functions *********************************\\
//**************************************************************************\\
}
