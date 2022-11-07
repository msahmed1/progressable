import 'dart:io';

import 'package:exercise_journal/src/blocs/workout_planning_bloc.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/custom_alert_dialog.dart';
import 'package:exercise_journal/src/widgets/dropdown_button.dart';
import 'package:exercise_journal/src/widgets/edit_aerobic_details.dart';
import 'package:exercise_journal/src/widgets/edit_strength_details.dart';
import 'package:exercise_journal/src/widgets/select_exercise_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

enum ExerciseType { addNew, update, addSubstitute }

class EditExercise extends StatefulWidget {
  //***************************** local variables *****************************\\
  static const String addNew = 'add_new';
  static const String update = 'update';
  static const String addSubstitute = 'add_substitute';

  final ExerciseType exerciseType;
  final int sequencePos;
  final int subSequencePos;

  //**************************************************************************\\
  //***************************** Constructor ********************************\\
  //**************************************************************************\\
  const EditExercise({
    super.key,
    this.sequencePos = -1,
    this.subSequencePos = -1,
    required this.exerciseType,
  });

  @override
  State<EditExercise> createState() => _EditExerciseState();
}

class _EditExerciseState extends State<EditExercise> {
  //***************************** local variables *****************************\\
  late ExerciseType exerciseType = widget.exerciseType;
  final List<String> workoutType = ['Strength Training', 'Aerobic Training'];

  //**************************************************************************\\
  //*************************** build Function *******************************\\
  //**************************************************************************\\
  @override
  Widget build(BuildContext context) {
    WorkoutPlanBloc planingBloc = Provider.of<WorkoutPlanBloc>(context);

    if (Platform.isIOS) {
      return WillPopScope(
        onWillPop: () async => !Navigator.of(context).userGestureInProgress,
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            border: null,
            leading: GestureDetector(
              child: Icon(
                CupertinoIcons.left_chevron,
                color: AppColours.primaryButton,
              ),
              onTap: () => _onExitPressed(),
            ),
            middle: Text(
              displayTitle(exerciseType),
              style: TextStyles.title,
            ),
            backgroundColor: AppColours.appBar,
          ),
          child: SafeArea(child: pageBody(planingBloc, isIOS: true)),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomAlertDialog(
              title: "Exit",
              description: "If you leave now your exercise will not be added",
              primaryButtonText: 'Stay',
              primaryButton: () {
                Navigator.of(context).pop(false);
              },
              secondaryButtonText: 'Leave',
              secondaryButton: () {
                int count = 0;
                Provider.of<WorkoutPlanBloc>(context, listen: false)
                    .nullifyExercise(); // listen set to false to prevent any listener from rebuilding
                Navigator.of(context).popUntil((_) => count++ >= 2);
                // Navigator.of(context).pop(true);
              },
            ),
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.arrowLeft,
                color: AppColours.primaryButton,
              ),
              onPressed: () => _onExitPressed(),
            ),
            title: Text(
              displayTitle(exerciseType),
              style: TextStyles.title,
            ),
            backgroundColor: AppColours.appBar,
          ),
          body: pageBody(planingBloc, isIOS: false),
        ),
      );
    }
  }

  //**************************************************************************\\
  //****************************** Functions *********************************\\
  //**************************************************************************\\
  Widget pageBody(WorkoutPlanBloc planingBloc, {required bool isIOS}) {
    // I'm using stream builder twice to look up workoutType, it would be less code if I just called it once and housed everything inside

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: exerciseType ==
                  ExerciseType
                      .addNew //If updating or adding substitute, don't show select workout type dropdown
              ? StreamBuilder<String>(
                  stream: planingBloc.workoutType,
                  builder: (context, snapshot) {
                    return AppDropdownButton(
                      value: snapshot.hasData ? snapshot.data.toString() : '',
                      hintText: 'select a workout type',
                      items: workoutType,
                      onChanged: (item) {
                        planingBloc.changeWorkoutType(item);
                      },
                    );
                  },
                )
              : Container(),
        ),
        StreamBuilder(
          stream: planingBloc.workoutType,
          builder: (context, snapshot) {
            if (snapshot.data != '') {
              // display input fields if workout type has not been selected
              return Column(
                children: [
                  if (exerciseType == ExerciseType.addNew)
                    Container()
                  else
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        snapshot.data.toString(),
                        style: TextStyles.buttonText
                            .copyWith(color: AppColours.suggestion),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'select exercise type',
                      style: TextStyles.suggestion,
                    ),
                  ),
                  StreamBuilder<String>(
                    stream: planingBloc.exerciseType,
                    builder: (context, snapshot) {
                      return ExerciseTypeSelector(
                        value: snapshot.data == null
                            ? ''
                            : snapshot.data.toString(),
                        onChange: planingBloc.changeExerciseType,
                      );
                    },
                  ),
                  if (snapshot.data == 'Aerobic Training')
                    EditAerobicTraining(
                      isUpdate: exerciseType == ExerciseType.update,
                      sequencePos: widget.sequencePos,
                      subSequencePos: widget.subSequencePos,
                    )
                  else
                    EditStrengthTraining(
                      isUpdate: exerciseType == ExerciseType.update,
                      sequencePos: widget.sequencePos,
                      subSequencePos: widget.subSequencePos,
                    )
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  Future _onExitPressed() async {
    return (Platform.isIOS)
        ? showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => showAlertDialog(context),
          )
        : showDialog(
            context: context,
            builder: (BuildContext context) => showAlertDialog(context),
          );
  }

  //**************************************************************************\\
  //************************* Supporting Functions ****************************\\
  //**************************************************************************\\
  String displayTitle(ExerciseType exerciseType) {
    if (exerciseType == ExerciseType.update) {
      return 'Update exercise';
    } else if (exerciseType == ExerciseType.addSubstitute) {
      return 'Substitute exercise';
    } else {
      return 'Add a exercise';
    }
  }

  Widget showAlertDialog(BuildContext context) {
    return CustomAlertDialog(
      title: "Exit",
      description: "If you leave now your exercise will not be added",
      primaryButtonText: 'Stay',
      primaryButton: () {
        Navigator.of(context).pop();
      },
      secondaryButtonText: 'Leave',
      secondaryButton: () {
        Provider.of<WorkoutPlanBloc>(context, listen: false).nullifyExercise();
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
      },
    );
  }
}
