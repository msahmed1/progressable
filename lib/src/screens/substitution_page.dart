import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/app.dart';
import 'package:exercise_journal/src/blocs/auth_bloc.dart';
import 'package:exercise_journal/src/blocs/workout_planning_bloc.dart';
import 'package:exercise_journal/src/screens/edit_a_exercise.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:exercise_journal/src/widgets/custom_alert_dialog.dart';
import 'package:exercise_journal/src/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/workout_planning_template/strength_training.dart';

class SubstituteExercise extends StatefulWidget {
  static const String id = 'SubstituteExercise';

  const SubstituteExercise({super.key});

  @override
  State<SubstituteExercise> createState() => _SubstituteExerciseState();
}

class _SubstituteExerciseState extends State<SubstituteExercise> {
  //***************************** local variables *****************************\\
  UnfocusDisposition disposition = UnfocusDisposition.scope;
  int? groupValue = 0;
  static const double verticalSpacing = 10.0;
  static const double horizontalSpacing = 10.0;

  //**************************************************************************\\
  //*************************** build Functions ******************************\\
  //**************************************************************************\\
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    WorkoutPlanBloc planingBloc = Provider.of<WorkoutPlanBloc>(context);

    return StreamBuilder<int>(
      stream: authBloc.substituteExerciseLimiter,
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == null) {
          return const LoadingIndicator();
        }

        final int substituteLimit = snapshot.hasData ? snapshot.data! : 0;

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
                  onTap: () {
                    _onExitPressed();
                  },
                ),
                middle: Text(
                  'Substitute Exercise',
                  style: TextStyles.title,
                ),
                backgroundColor: AppColours.appBar,
              ),
              child: SafeArea(
                child: pageBody(planingBloc, substituteLimit, isIOS: true),
              ),
            ),
          );
        } else {
          return WillPopScope(
            onWillPop: () async {
              _onExitPressed();
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.arrowLeft,
                    color: AppColours.primaryButton,
                  ),
                  onPressed: () {
                    _onExitPressed();
                  },
                ),
                title: Text(
                  'Substitute Exercise',
                  style: TextStyles.title,
                ),
                backgroundColor: AppColours.appBar,
              ),
              body: pageBody(planingBloc, substituteLimit, isIOS: false),
            ),
          );
        }
      },
    );
  }

  //**************************************************************************\\
  //****************************** Functions *********************************\\
  //**************************************************************************\\
  Widget pageBody(
    WorkoutPlanBloc planingBloc,
    int substituteLimit, {
    required bool isIOS,
  }) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: planingBloc.substituteExercises,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: verticalSpacing),
                    generateList(snapshot.data!),
                  ],
                ),
              ),
              AppButton(
                buttonType: ButtonType.primary,
                buttonText: 'Add Exercise',
                onPressed: () {
                  if ((snapshot.data?.length ?? 0) >= substituteLimit) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          showAlertDialog(context, substituteLimit),
                    );
                  } else {
                    primaryFocus!.unfocus(disposition: disposition);
                    Navigator.of(context)
                        .pushNamed(
                          '${EditExercise.addSubstitute}/${snapshot.data!['0']?.sequence}',
                        )
                        .then((value) => setState(() {}));
                  }
                },
              ),
              AppButton(
                buttonType: ButtonType.primary,
                buttonText: 'Save',
                onPressed: () {
                  //pass data back to journaling block to update the current workout
                  // int newPrimary = groupValue != null ? groupValue.toInt() : 0;
                  const int primaryPosition = 0; // default to first index pos
                  journalingBloc.saveSubstitute(
                    snapshot.data,
                    oldSubSequencePos: groupValue ?? primaryPosition,
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  //**************************************************************************\\
  //************************* Supporting Functions ****************************\\
  //**************************************************************************\\
  Widget generateList(Map<String, dynamic> exerciseMap) {
    List<Widget> listOfTiles = [];

    exerciseMap.forEach((key, exercise) {
      listOfTiles.add(
        Column(
          children: [
            const Divider(
              thickness: 1.0,
            ),
            Material(
              child: ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: AutoSizeText(
                        exercise.runtimeType == StrengthTraining
                            ? exercise.strengthExerciseName as String
                            : exercise.aerobicExerciseName as String,
                        // ignore: avoid_redundant_argument_values
                        style: TextStyles.title.copyWith(fontSize: null),
                        maxLines: 1,
                        maxFontSize: 26,
                      ),
                    ),
                    const SizedBox(width: horizontalSpacing),
                    // Expanded(
                    //   child: AutoSizeText(
                    //     '(Set: ${exercise.sets})',
                    //     style: TextStyles.suggestion,
                    //     maxLines: 1,
                    //   ),
                    // ),
                  ],
                ),
                leading: Radio<int>(
                  value: exercise.subSequence as int,
                  groupValue: groupValue,
                  onChanged: (int? value) => setState(() {
                    groupValue = value;
                  }),
                ),
              ),
            ),
            const Divider(
              thickness: 1.0,
            ),
            if (exerciseMap.length == 1)
              Text(
                "Add a substitute exercise by clicking 'Add Exercise' bellow",
                style: TextStyles.suggestion,
                textAlign: TextAlign.center,
              )
            else
              Container()
          ],
        ),
      );
    });

    return Column(
      children: listOfTiles,
    );
  }

  Future _onExitPressed() async {
    return (Platform.isIOS)
        ? showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => showExitAlertDialog(context),
          )
        : showDialog(
            context: context,
            builder: (BuildContext context) => showExitAlertDialog(context),
          );
  }

  Widget showExitAlertDialog(BuildContext context) {
    return CustomAlertDialog(
      title: "Exit",
      description: "If you leave now your changes will not be saved",
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
    );
  }

  Widget showDeleteAlertDialog(BuildContext context) {
    return CustomAlertDialog(
      title: "Exit",
      description: 'If you exit your changes will not be saved',
      primaryButtonText: 'Stay',
      primaryButton: () {
        Navigator.of(context).pop(false);
      },
      secondaryButtonText: 'Exit',
      secondaryButton: () {
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
      },
    );
  }

  //show dialog function
  Widget showAlertDialog(BuildContext context, int substituteLimit) {
    return CustomAlertDialog(
      title: "Limit",
      description:
          'We have limited substitute exercises to $substituteLimit to limit our infrastructure costs ',
      primaryButtonText: 'Continue',
      primaryButton: () {
        Navigator.of(context).pop(false);
      },
    );
  }
}
