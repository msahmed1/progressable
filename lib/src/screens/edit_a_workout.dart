import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/blocs/auth_bloc.dart';
import 'package:exercise_journal/src/blocs/format_time.dart';
import 'package:exercise_journal/src/blocs/workout_planning_bloc.dart';
import 'package:exercise_journal/src/models/workout_planning_template/a_workout.dart';
import 'package:exercise_journal/src/models/workout_planning_template/aerobic_training.dart';
import 'package:exercise_journal/src/models/workout_planning_template/strength_training.dart';
import 'package:exercise_journal/src/screens/edit_a_exercise.dart';
import 'package:exercise_journal/src/styles/base.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/app_textfield.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:exercise_journal/src/widgets/custom_alert_dialog.dart';
import 'package:exercise_journal/src/widgets/exercise_type_representation.dart';
import 'package:exercise_journal/src/widgets/loading_indicator.dart';
import 'package:exercise_journal/src/widgets/weekday_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditAWorkout extends StatefulWidget {
  static const String id = 'add_new_workout';
  final String workoutID;

  const EditAWorkout({
    super.key,
    this.workoutID = '',
  });

  @override
  State<EditAWorkout> createState() => _EditAWorkoutState();
}

class _EditAWorkoutState extends State<EditAWorkout> {
  UnfocusDisposition disposition = UnfocusDisposition.scope;
  bool firstRun = true;
  String pageLabel = 'Add Workout';
  String buttonLabel = 'Save';

  @override
  Widget build(BuildContext context) {
    var planingBloc = Provider.of<WorkoutPlanBloc>(context);
    var authBloc = Provider.of<AuthBloc>(context);

    AWorkout existingWorkout = AWorkout(
      workoutName: '',
      strengthExercises: [],
      aerobicExercises: [],
      activeDays: [],
      workoutID: '',
      userID: '',
      workoutNote: '',
      workoutDuration: 0,
    );

    return StreamBuilder<int>(
      stream: authBloc.exerciseLimiter,
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == null) {
          return const LoadingIndicator(text: 'Getting your workout ready');
        }

        final int exerciseLimit = snapshot.hasData ? snapshot.data! : 0;

        if (firstRun) {
          firstRun = false;

          if (widget.workoutID != '') {
            return FutureBuilder<AWorkout>(
              future: planingBloc.getAWorkout(
                authBloc.userID.toString(),
                widget.workoutID,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const LoadingIndicator(
                    text: 'Getting your workout ready',
                  );
                } else {
                  existingWorkout = snapshot.data!;
                  loadValues(
                    planingBloc,
                    existingWorkout,
                    authBloc.userID.toString(),
                  );

                  pageLabel = 'Edit Workout';
                  buttonLabel = 'Update';

                  return buildScaffold(
                    planingBloc,
                    existingWorkout,
                    exerciseLimit,
                  );
                }
              },
            );
          } else {
            loadValues(
              planingBloc,
              existingWorkout,
              authBloc.userID.toString(),
            );
            pageLabel = 'Add Workout';
            buttonLabel = 'Save';
            return buildScaffold(planingBloc, existingWorkout, exerciseLimit);
          }
        } else {
          return buildScaffold(planingBloc, existingWorkout, exerciseLimit);
        }
      },
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

  Future _onDeletePressed(AWorkout existingWorkout) {
    return (Platform.isIOS)
        ? showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => showDeleteAlertDialog(
              context,
              existingWorkout,
            ),
          )
        : showDialog(
            context: context,
            builder: (BuildContext context) => showDeleteAlertDialog(
              context,
              existingWorkout,
            ),
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

  Widget showDeleteAlertDialog(BuildContext context, AWorkout existingWorkout) {
    return CustomAlertDialog(
      title: "Delete",
      description: 'Are you sure you want to permanently delete this workout?',
      primaryButtonText: 'No',
      primaryButton: () {
        Navigator.of(context).pop(false);
      },
      secondaryButtonText: 'Yes',
      secondaryButton: () {
        int count = 0;
        Provider.of<WorkoutPlanBloc>(context, listen: false)
            .deleteWorkout(existingWorkout);
        Navigator.of(context).popUntil((_) => count++ >= 2);
      },
    );
  }

  Widget buildScaffold(
    WorkoutPlanBloc planingBloc,
    AWorkout existingWorkout,
    int exerciseLimit,
  ) {
    return (Platform.isIOS)
        ? WillPopScope(
            onWillPop: () async => !Navigator.of(context).userGestureInProgress,
            child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                leading: GestureDetector(
                  child: Icon(
                    CupertinoIcons.clear_thick,
                    color: AppColours.primaryButton,
                  ),
                  onTap: () => _onExitPressed(),
                ),
                middle: Text(
                  pageLabel,
                  style: TextStyles.title,
                ),
                trailing: widget.workoutID == ''
                    ? Container()
                    : GestureDetector(
                        child: Icon(
                          CupertinoIcons.delete,
                          color: AppColours.delete,
                        ),
                        onTap: () => _onDeletePressed(existingWorkout),
                      ),
                backgroundColor: AppColours.appBar,
              ),
              child: SafeArea(
                child: pageBody(
                  context,
                  planingBloc,
                  exerciseLimit,
                  isIOS: true,
                ),
              ),
            ),
          )
        : WillPopScope(
            onWillPop: () async {
              _onExitPressed();
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.xmark,
                    color: AppColours.primaryButton,
                  ),
                  onPressed: () => _onExitPressed(),
                ),
                title: Text(
                  pageLabel,
                  style: TextStyles.title,
                ),
                actions: <Widget>[
                  if (widget.workoutID == '')
                    Container()
                  else
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        color: AppColours.delete,
                      ),
                      onPressed: () => _onDeletePressed(existingWorkout),
                    )
                ],
                backgroundColor: AppColours.appBar,
              ),
              body: pageBody(context, planingBloc, exerciseLimit, isIOS: false),
            ),
          );
  }

  Widget pageBody(
    BuildContext context,
    WorkoutPlanBloc planingBloc,
    int exerciseLimit, {
    required bool isIOS,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(
          height: 8.0,
        ),
        StreamBuilder<String?>(
          stream: planingBloc.workoutName,
          builder: (context, snapshot) {
            return AppTextField(
              hintText: 'Workout Name',
              isIOS: isIOS,
              errorText: snapshot.hasError ? snapshot.error.toString() : '',
              initialText: snapshot.hasData ? snapshot.data.toString() : '',
              onChanged: planingBloc.changeWorkoutName,
            );
          },
        ),
        StreamBuilder<List<bool>>(
          stream: planingBloc.activeDays,
          builder: (context, snapshot) {
            return ActiveDayPicker(
              initVal: snapshot.hasData
                  ? snapshot.data!
                  : List<bool>.generate(7, (int index) => false),
              onChange: (days) =>
                  planingBloc.changeActiveDays(days as List<bool>),
            );
          },
        ),
        const SizedBox(
          height: 8.0,
        ),
        Expanded(
          child: Scaffold(
            backgroundColor: AppColours.background,
            body: _buildExerciseList(planingBloc),
          ),
        ),
        StreamBuilder<Map<int, dynamic>>(
          stream: planingBloc.orderedPrimaryExercises,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AppButton(
                buttonType: ButtonType.primary,
                buttonText: 'Add Exercise',
                onPressed: () {
                  if ((snapshot.data?.length ?? 0) >= 5) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          showAlertDialog(context, exerciseLimit),
                    );
                  } else {
                    primaryFocus!.unfocus(disposition: disposition);
                    Navigator.of(context)
                        .pushNamed(EditExercise.addNew)
                        .then((value) => setState(() {}));
                  }
                },
              );
            }
            return Container();
          },
        ),
        StreamBuilder<bool>(
          stream: planingBloc.isValid,
          builder: (context, snapshot) {
            bool buttonActive = false;
            if (snapshot.hasData) {
              snapshot.data == true
                  ? buttonActive = true
                  : buttonActive = false;
            }

            return AppButton(
              buttonType:
                  buttonActive ? ButtonType.primary : ButtonType.disabled,
              buttonText: buttonLabel,
              onPressed: () {
                planingBloc.saveWorkout();
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ],
    );
  }

  void loadValues(
    WorkoutPlanBloc planingBloc,
    AWorkout workout,
    String userID,
  ) {
    planingBloc.loadWorkout(workout);
    planingBloc.changeUserID(userID);

    // The following should ideally happen in the planning bloc in the changeWorkout()
    // if (workout.workoutName != '') {
    //   planingBloc.changeWorkoutName(workout.workoutName);
    //   planingBloc.changeActiveDays(workout.activeDays);
    // } else {
    //   //How is this going to be possible, if you click edit a workout it should have a name. it's not possible to save a blank workout
    //   // Unless its initialise to '' from not being able to read from the cloud
    //   planingBloc.nullifyAll();
    // }
  }

  Widget _buildExerciseList(WorkoutPlanBloc planingBloc) {
    return StreamBuilder<Map<int, dynamic>>(
      stream: planingBloc.orderedPrimaryExercises,
      builder: (context, snapshot) {
        // I could just use the ?? operator

        if (snapshot.hasData) {
          final orderedExercises = snapshot.data!;
          return ReorderableListView(
            onReorder: (int oldIndex, int newIndex) {
              planingBloc.reorder(
                oldIdx: oldIndex,
                newIdx: newIndex,
              );
            },
            physics: const BouncingScrollPhysics(),
            children:
                List<Padding>.generate(orderedExercises.length, (int index) {
              // for each item in the list generate a card
              final aExercise = orderedExercises[index];

              String title = '';
              String subTitle = '';
              String workoutType = '';
              if (aExercise is StrengthTraining) {
                title = aExercise.strengthExerciseName;
                subTitle = 'Sets: ${aExercise.sets}';
                workoutType = aExercise.exerciseType;
              } else if (aExercise is AerobicTraining) {
                title = aExercise.aerobicExerciseName;
                if (aExercise.enableDistance) {
                  subTitle = '${subTitle}Dist: ${aExercise.distance[0]}m';
                  if (aExercise.enableDuration || aExercise.enableCalories) {
                    subTitle = '$subTitle,';
                  }
                }
                if (aExercise.enableDuration) {
                  subTitle =
                      '$subTitle Time: ${FormatTime().displayTime(aExercise.duration[0])}';
                  if (aExercise.enableCalories) {
                    subTitle = '$subTitle,';
                  }
                }
                if (aExercise.enableCalories) {
                  subTitle = '$subTitle Kal: ${aExercise.calories}';
                }
                workoutType = aExercise.exerciseType;
              }
              return Padding(
                key: ValueKey(index),
                padding: BaseStyles.listPadding,
                child: Card(
                  child: ListTile(
                    dense: true,
                    leading: WorkoutTypeColorRepresentation(
                      exercise: aExercise,
                      exerciseType: workoutType,
                    ),
                    title: AutoSizeText(
                      title,
                      style: TextStyles.cardTitle,
                      maxLines: 1,
                    ),
                    subtitle: AutoSizeText(
                      subTitle,
                      style: TextStyles.cardBody,
                      maxLines: 1,
                      minFontSize: 8.0,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            primaryFocus!.unfocus(disposition: disposition);
                            planingBloc.setUpExerciseForEditing(aExercise);
                            Navigator.of(context).pushNamed(
                              '${EditExercise.update}/${aExercise.sequence}/${aExercise.subSequence}',
                            );
                          },
                          icon: Icon(
                            FontAwesomeIcons.pencil,
                            color: AppColours.edit,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              primaryFocus!.unfocus(disposition: disposition);
                              planingBloc.deleteExercise(aExercise);
                            });
                          },
                          icon: Icon(
                            FontAwesomeIcons.trash,
                            color: AppColours.delete,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        } else {
          return Padding(
            padding: BaseStyles.listPadding,
            child: Text(
              "Your workout is empty to add exercises to this workout click 'Add Exercise' Below",
              style: TextStyles.body,
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }

  //show dialog function
  Widget showAlertDialog(BuildContext context, int exerciseLimit) {
    return CustomAlertDialog(
      title: "Limit reached",
      description:
          'We have limited exercises to $exerciseLimit to keep our infrastructure costs down',
      primaryButtonText: 'Continue',
      primaryButton: () {
        Navigator.of(context).pop(false);
      },
    );
  }
}

// enum Item { select, strengthTraining, aerobicTraining }
