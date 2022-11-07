import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/blocs/format_time.dart';
import 'package:exercise_journal/src/blocs/journaling_bloc.dart';
import 'package:exercise_journal/src/blocs/workout_planning_bloc.dart';
import 'package:exercise_journal/src/models/workout_planning_template/aerobic_training.dart';
import 'package:exercise_journal/src/models/workout_planning_template/strength_training.dart';
import 'package:exercise_journal/src/screens/edit_note_page.dart';
import 'package:exercise_journal/src/screens/journal_entry.dart';
import 'package:exercise_journal/src/screens/substitution_page.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JournalTable extends StatelessWidget {
  //***************************** local variables *****************************\\
  final dynamic target;
  final dynamic actual;

  //**************************************************************************\\
  //***************************** Constructor ********************************\\
  //**************************************************************************\\
  const JournalTable({super.key, @required this.target, @required this.actual});

  //**************************************************************************\\
  //*************************** build Function *******************************\\
  //**************************************************************************\\
  @override
  Widget build(BuildContext context) {
    final journalBloc = Provider.of<JournalingBloc>(context);
    final planingBloc = Provider.of<WorkoutPlanBloc>(context);
    if (target is StrengthTraining) {
      return strengthTrainingTable(context, journalBloc, planingBloc);
    }
    return aerobicTrainingTable(context, journalBloc, planingBloc);
  }

  //**************************************************************************\\
  //****************************** Functions *********************************\\
  //**************************************************************************\\
  Widget aerobicTrainingTable(
    BuildContext context,
    JournalingBloc journalBloc,
    WorkoutPlanBloc planingBloc,
  ) {
    return Column(
      children: <Widget>[
        // Display target labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  '',
                  style: TextStyles.suggestion,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Target',
                  style: TextStyles.suggestion,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  'Log',
                  style: TextStyles.suggestion,
                ),
              ),
            ),
          ],
        ),

        // Display targets
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    if (target.enableDistance == true)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Distance',
                            style: TextStyles.suggestion,
                          ),
                          if (target.enableDuration == true ||
                              target.enableCalories == true ||
                              target.enableRPE == true)
                            Divider(
                              thickness: 1,
                              color: AppColours.suggestion,
                            )
                          else
                            Container(),
                        ],
                      )
                    else
                      Container(),
                    if (target.enableDuration == true)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Duration',
                            style: TextStyles.suggestion,
                          ),
                          if (target.enableCalories == true ||
                              target.enableRPE == true)
                            Divider(
                              thickness: 1,
                              color: AppColours.suggestion,
                            )
                          else
                            Container(),
                        ],
                      )
                    else
                      Container(),
                    if (target.enableCalories == true)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Calories',
                            style: TextStyles.suggestion,
                          ),
                          if (target.enableRPE == true)
                            Divider(
                              thickness: 1,
                              color: AppColours.suggestion,
                            )
                          else
                            Container(),
                        ],
                      )
                    else
                      Container(),
                    if (target.enableRPE == true)
                      Text(
                        'RPE',
                        style: TextStyles.suggestion,
                      )
                    else
                      Container(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Column(
                  children: <Widget>[
                    if (target.enableDistance == true)
                      Column(
                        children: [
                          Text(
                            '${target.distance[0] ?? '0.0'} m',
                            style: TextStyles.suggestion,
                          ),
                          if (target.enableDuration == true ||
                              target.enableCalories == true ||
                              target.enableRPE == true)
                            Divider(
                              thickness: 1,
                              color: AppColours.suggestion,
                            )
                          else
                            Container(),
                        ],
                      )
                    else
                      Container(),
                    if (target.enableDuration == true)
                      Column(
                        children: [
                          Text(
                            target.duration[0] != null
                                ? FormatTime()
                                    .displayTime(target.duration[0] as int)
                                : '0:0',
                            style: TextStyles.suggestion,
                          ),
                          if (target.enableCalories == true ||
                              target.enableRPE == true)
                            Divider(
                              thickness: 1,
                              color: AppColours.suggestion,
                            )
                          else
                            Container(),
                        ],
                      )
                    else
                      Container(),
                    if (target.enableCalories == true)
                      Column(
                        children: [
                          Text(
                            target.calories != null
                                ? target.calories.toString()
                                : '0',
                            style: TextStyles.suggestion,
                          ),
                          if (target.enableRPE == true)
                            Divider(
                              thickness: 1,
                              color: AppColours.suggestion,
                            )
                          else
                            Container(),
                        ],
                      )
                    else
                      Container(),
                    if (target.enableRPE == true)
                      Text(
                        target.rateOfPerceivedExertion[0] != null
                            ? target.rateOfPerceivedExertion[0].toString()
                            : '0',
                        style: TextStyles.suggestion,
                      )
                    else
                      Container(),
                  ],
                ),
              ),
            ),
            // Extracting from Map element the value
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyles.body,
                    backgroundColor: AppColours.primaryButton,
                  ),
                  onPressed: () {
                    journalBloc.changeExerciseName(
                      actual.aerobicExerciseName as String,
                    );
                    journalBloc.changeDistance(
                      actual.distance[0] == 0
                          ? target.distance[0].toString()
                          : actual.distance[0].toString(),
                    );
                    journalBloc.changeDuration(actual.duration[0] == 0
                        ? target.duration[0] as int
                        : actual.duration[0] as int);
                    journalBloc.changeCalories(actual.calories == 0
                        ? target.calories.toString()
                        : actual.calories.toString());
                    journalBloc.changeRPE(
                      actual.rateOfPerceivedExertion[0] == 0
                          ? target.rateOfPerceivedExertion[0].toString()
                          : actual.rateOfPerceivedExertion[0].toString(),
                    );
                    journalBloc
                        .changeEnableDuration(actual?.enableDuration as bool);
                    journalBloc.changeEnableRPE(actual?.enableRPE as bool);

                    journalBloc
                        .changeEnableCalories(actual?.enableCalories as bool);

                    Navigator.of(context).pushNamed(
                      '${JournalEntry.id}/${actual.sequence}/aerobic',
                    );
                  },
                  child: _aerobicButtonLabel(actual! as AerobicTraining),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              actual.note as String,
              style: TextStyles.suggestion,
            ),
          ),
        ),
        Row(
          children: [
            // addSet(),
            addNote(context),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 1.0)),
            substituteExerciseButton(journalBloc, planingBloc, context),
          ],
        )
      ],
    );
  }

  Widget strengthTrainingTable(
    BuildContext context,
    JournalingBloc journalBloc,
    WorkoutPlanBloc planingBloc,
  ) {
    return Column(
      children: <Widget>[
        // set up titles
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  'Set',
                  style: TextStyles.suggestion,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  'Targets',
                  style: TextStyles.suggestion,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  'Log',
                  style: TextStyles.suggestion,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Column(
          //set up each row in weight training table
          children: List<Widget>.generate(
            target.sets as int,
            (int setNumber) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Text(
                            (setNumber + 1).toString(),
                            // +1 because setNumber declared in .generate() starts at 0
                            style: TextStyles.suggestion,
                          ),
                        ),
                      ), //Extracting from Map element the value
                      // Display target labels
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Weight: ',
                                  style: TextStyles.suggestion,
                                ),
                                Text(
                                  'Reps: ',
                                  style: TextStyles.suggestion,
                                ),
                                if (target.enableRPE == true)
                                  Text(
                                    'RPE: ',
                                    style: TextStyles.suggestion,
                                  )
                                else
                                  Container(),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  target.targetWeights[setNumber] == null
                                      ? '0'
                                      : target.targetWeights[setNumber]
                                          .toString(),
                                  style: TextStyles.suggestion,
                                ),
                                Text(
                                  target.targetReps[setNumber] == null
                                      ? '0'
                                      : target.targetReps[setNumber].toString(),
                                  style: TextStyles.suggestion,
                                ),
                                if (target.enableRPE == true)
                                  Text(
                                    target.rateOfPerceivedExertion[setNumber] ==
                                            null
                                        ? '0'
                                        : target
                                            .rateOfPerceivedExertion[setNumber]
                                            .toString(),
                                    style: TextStyles.suggestion,
                                  )
                                else
                                  Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Display targets
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyles.body,
                              backgroundColor: AppColours.primaryButton,
                            ),
                            onPressed: () {
                              journalBloc.changeExerciseName(
                                actual.strengthExerciseName as String,
                              );

                              journalBloc.changeCurrentSet(setNumber);
                              journalBloc.changeWeight(
                                actual?.targetWeights[setNumber] == 0.0
                                    ? (target?.targetWeights[setNumber] == 0.0
                                        ? null
                                        : target.targetWeights[setNumber]
                                            .toString())
                                    : actual?.targetWeights[setNumber]
                                        .toString(),
                              );
                              journalBloc.changeRep(
                                actual?.targetReps[setNumber] == 0.0
                                    ? (target?.targetReps[setNumber] == 0.0
                                        ? null
                                        : target.targetReps[setNumber]
                                            .toString())
                                    : actual?.targetReps[setNumber].toString(),
                              );
                              journalBloc.changeRPE(
                                actual?.rateOfPerceivedExertion[setNumber] == 0
                                    ? target.rateOfPerceivedExertion[setNumber]
                                        .toString()
                                    : (actual?.rateOfPerceivedExertion[
                                            setNumber])
                                        .toString(),
                              );
                              journalBloc
                                  .changeEnableRPE(actual?.enableRPE as bool);

                              Navigator.of(context).pushNamed(
                                '${JournalEntry.id}/${target.sequence}/strength',
                              );
                            },
                            child: _strengthButtonLabel(
                              actual! as StrengthTraining,
                              setNumber,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  if (target.sets - 1 == setNumber)
                    Container()
                  else
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        thickness: 1.0,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              actual.note as String,
              style: TextStyles.suggestion,
            ),
          ),
        ),

        //Display auxiliary buttons
        Row(
          children: [
            // addSet(),
            addNote(context),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 1.0)),
            substituteExerciseButton(journalBloc, planingBloc, context),
          ],
        )
      ],
    );
  }

  //**************************************************************************\\
  //************************* Supporting Functions ****************************\\
  //**************************************************************************\\

  Widget _strengthButtonLabel(StrengthTraining currentExercise, int setNum) {
    if (currentExercise.targetWeights[setNum] != 0 ||
        currentExercise.targetReps[setNum] != 0) {
      final weight = currentExercise.targetWeights[setNum];
      final reps = currentExercise.targetReps[setNum];
      final RPE = currentExercise.rateOfPerceivedExertion[setNum];

      return Column(
        key: Key(currentExercise.targetWeights[setNum].toString()),
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          AutoSizeText(
            '${weight}kg x $reps',
            maxLines: 1,
            maxFontSize: 16,
          ),
          AutoSizeText(
            'RPE: $RPE',
            maxLines: 1,
            maxFontSize: 16,
          ),
        ],
      );
    }

    return const Text('+ Record');
  }

  Widget _aerobicButtonLabel(AerobicTraining currentExercise) {
    if (currentExercise.duration[0] == 0 && currentExercise.distance[0] == 0) {
      return const Text('+ Record');
    } else {
      return Column(
        key: Key(currentExercise.distance[0].toString()),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (currentExercise.enableDistance)
            Column(
              children: [
                Text('${currentExercise.distance[0]} m'),
                if (currentExercise.enableDuration == true ||
                    currentExercise.enableCalories == true ||
                    currentExercise.enableRPE == true)
                  Divider(
                    thickness: 1,
                    color: AppColours.forground,
                  )
                else
                  Container(),
              ],
            )
          else
            Container(),
          if (currentExercise.enableDuration)
            Column(
              children: [
                Text(
                  FormatTime().displayTime(currentExercise.duration[0]),
                ),
                if (currentExercise.enableCalories == true ||
                    currentExercise.enableRPE == true)
                  Divider(
                    thickness: 1,
                    color: AppColours.forground,
                  )
                else
                  Container(),
              ],
            )
          else
            Container(),
          if (currentExercise.enableCalories)
            Column(
              children: [
                Text('${currentExercise.calories}'),
                if (currentExercise.enableRPE == true)
                  Divider(
                    thickness: 1,
                    color: AppColours.forground,
                  )
                else
                  Container(),
              ],
            )
          else
            Container(),
          if (currentExercise.enableRPE)
            Text('${currentExercise.rateOfPerceivedExertion[0]}')
          else
            Container(),
        ],
      );
    }
  }

  Widget addSet() {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColours.shadow,
          backgroundColor: AppColours.primaryButton,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
            ),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
            ),
          ),
          alignment: Alignment.center,
          child: AutoSizeText(
            'Add set',
            maxLines: 1,
            style: TextStyles.buttonText,
          ),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget addNote(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColours.shadow,
          backgroundColor: AppColours.primaryButton,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              // topRight: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
            ),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              // topRight: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          alignment: Alignment.center,
          child: AutoSizeText(
            'Note',
            maxLines: 1,
            style: TextStyles.buttonText,
          ),
        ),
        onPressed: () {
          Navigator.of(context)
              .pushNamed('${EditNotesView.id}/${target.sequence}');
        },
      ),
    );
  }

  Widget substituteExerciseButton(
    JournalingBloc journalBloc,
    WorkoutPlanBloc planingBloc,
    BuildContext context,
  ) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColours.shadow,
          backgroundColor: AppColours.primaryButton,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              // bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              // bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          alignment: Alignment.center,
          child: AutoSizeText(
            'Substitute',
            maxLines: 1,
            style: TextStyles.buttonText,
          ),
        ),
        onPressed: () {
          // Hand over data to workout planning block from journaling bloc
          journalBloc.aWorkout.listen((event) {
            //only pass the exercise sequence that will be edited
            planingBloc.loadWorkout(event);
            planingBloc.setUpSubstituteExercises(target.sequence as int);
          });
          // planingBloc.setUpSubstituteExercises(target.sequence);
          Navigator.of(context)
              .pushNamed('${SubstituteExercise.id}/${target.sequence}');
        },
      ),
    );
  }
}
