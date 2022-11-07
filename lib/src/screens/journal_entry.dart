import 'dart:io';

import 'package:exercise_journal/src/app.dart';
import 'package:exercise_journal/src/blocs/journaling_bloc.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/adaptive_slider.dart';
import 'package:exercise_journal/src/widgets/app_textfield.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:exercise_journal/src/widgets/reusable_card.dart';
import 'package:exercise_journal/src/widgets/rounded_icon_button.dart';
import 'package:exercise_journal/src/widgets/time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class JournalEntry extends StatefulWidget {
  //***************************** local variables *****************************\\
  static const String id = 'edit_journal_entry';

  final int sequence;
  final String exerciseType;

  //**************************************************************************\\
  //***************************** Constructor ********************************\\
  //**************************************************************************\\
  const JournalEntry({
    super.key,
    this.sequence = 0,
    this.exerciseType = '',
  });

  @override
  State<JournalEntry> createState() => _JournalEntryState();
}

class _JournalEntryState extends State<JournalEntry> {
  bool updateText = false;
  UnfocusDisposition disposition = UnfocusDisposition.scope;

  //**************************************************************************\\
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: journalingBloc.currentExerciseName,
      builder: (context, snapshot) {
        String? exerciseName = '';
        if (snapshot.hasData) {
          exerciseName = snapshot.data;
        } else {
          exerciseName = 'Journal Entry';
        }
        return Platform.isIOS
            ? WillPopScope(
                onWillPop: () async {
                  journalingBloc.nullifyInputs();
                  Navigator.of(context).pop();
                  return false;
                },
                child: CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    middle: Text(
                      exerciseName!,
                      // ignore: avoid_redundant_argument_values
                      style: TextStyles.title.copyWith(fontSize: null),
                    ),
                    // leading: Container(width: 0),
                    leading: GestureDetector(
                      child: Icon(
                        CupertinoIcons.chevron_back,
                        color: AppColours.primaryButton,
                      ),
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    backgroundColor: AppColours.appBar,
                  ),
                  child: pageBody(context),
                ),
              )
            : WillPopScope(
                onWillPop: () async {
                  journalingBloc.nullifyInputs();
                  Navigator.of(context).pop();
                  return false;
                },
                child: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: const Icon(FontAwesomeIcons.arrowLeft),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: Text(
                      exerciseName!,
                      // ignore: avoid_redundant_argument_values
                      style: TextStyles.title.copyWith(fontSize: null),
                    ),
                    backgroundColor: AppColours.appBar,
                  ),
                  body: pageBody(context),
                ),
              );
      },
    );
  }

  //**************************************************************************\\
  Widget pageBody(BuildContext context) {
    var journalBloc = Provider.of<JournalingBloc>(context);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: <Widget>[
              if (widget.exerciseType == 'aerobic')
                aerobicTrainingInputs(journalBloc)
              else
                strengthTrainingInputs(journalBloc),
              StreamBuilder<bool>(
                stream: journalBloc.enableRPE,
                builder: (context, rpeState) {
                  if (rpeState.data == false || rpeState.data == null) {
                    return Container();
                  }
                  return StreamBuilder<int>(
                    stream: journalBloc.rateOfPerceivedExertion,
                    builder: (context, snapshot) {
                      return ReusableCard(
                        backgroundColor: AppColours.forground,
                        cardChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Set your RPE?',
                                        style: TextStyles.body,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        snapshot.data == null
                                            ? '---'
                                            : snapshot.data.toString(),
                                        style: TextStyles.title,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: AdaptiveSlider(
                                                minVal: 0,
                                                maxVal: 10,
                                                initVal: 7,
                                                value: snapshot.data ?? 7,
                                                divisions: 11,
                                                onChange: (double weight) {
                                                  journalBloc.changeRPE(
                                                    (weight.round()).toString(),
                                                  );
                                                  updateText = true;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          buildSubmitButton(context, journalBloc),
        ],
      ),
    );
  }

  Widget aerobicTrainingInputs(JournalingBloc journalBloc) {
    return Column(
      children: [
        const SizedBox(height: 10),
        StreamBuilder<int>(
          stream: journalBloc.distance,
          builder: (context, snapshot) {
            return ReusableCard(
              backgroundColor: AppColours.forground,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'How far did you travel in meters?',
                    style: TextStyles.body,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
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
                                journalBloc
                                    .changeDistance('${snapshot.data! - 1}');
                              } else {
                                journalBloc.changeDistance('99999');
                              }
                            } else {
                              journalBloc.changeDistance('99999');
                            }
                            updateText = true;
                          },
                        ),
                        Expanded(
                          child: AppTextField(
                            isIOS: Platform.isIOS,
                            hintText: 'Distance in meters?',
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
                              journalBloc.changeDistance(keyBoardEvent);
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
                                journalBloc
                                    .changeDistance('${snapshot.data! + 1}');
                              } else {
                                journalBloc.changeDistance('1');
                              }
                            } else {
                              journalBloc.changeDistance('1');
                            }
                            updateText = true;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        StreamBuilder<bool>(
          stream: journalBloc.enableDuration,
          builder: (context, rpeState) {
            if (rpeState.data == false || rpeState.data == null) {
              return Container();
            }
            return StreamBuilder<int>(
              stream: journalBloc.duration,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ReusableCard(
                    backgroundColor: AppColours.forground,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Enter exercise duration?',
                          style: TextStyles.body,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TimePicker(
                          title: 'Enter time',
                          duration: snapshot.hasData ? snapshot.data! : 0,
                          isIOS: Platform.isIOS,
                          onChange: journalBloc.changeDuration,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          },
        ),
        StreamBuilder<bool>(
          stream: journalBloc.enableCalories,
          builder: (context, calorieState) {
            if (calorieState.data == false || calorieState.data == null) {
              return Container();
            }
            return StreamBuilder<int>(
              stream: journalBloc.calories,
              builder: (context, snapshot) {
                return ReusableCard(
                  backgroundColor: AppColours.forground,
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'How many calories did you burn?',
                        style: TextStyles.body,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
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
                                    journalBloc.changeCalories(
                                      '${snapshot.data! - 1}',
                                    );
                                  } else {
                                    journalBloc.changeCalories('9999');
                                  }
                                } else {
                                  journalBloc.changeCalories('9999');
                                }
                                updateText = true;
                              },
                            ),
                            Expanded(
                              child: AppTextField(
                                isIOS: Platform.isIOS,
                                hintText: 'Calories?',
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
                                  journalBloc.changeCalories(keyBoardEvent);
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
                                    journalBloc.changeCalories(
                                      '${snapshot.data! + 1}',
                                    );
                                  } else {
                                    journalBloc.changeCalories('1');
                                  }
                                } else {
                                  journalBloc.changeCalories('1');
                                }
                                updateText = true;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget strengthTrainingInputs(JournalingBloc journalBloc) {
    return Column(
      children: [
        const SizedBox(height: 10),
        StreamBuilder<double>(
          stream: journalBloc.weight,
          builder: (context, snapshot) {
            return ReusableCard(
              backgroundColor: AppColours.forground,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'How much weight did you lift in kg?',
                    style: TextStyles.body,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
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
                                journalBloc
                                    .changeWeight('${snapshot.data! - 1}');
                              } else {
                                journalBloc.changeWeight('1000');
                              }
                            } else {
                              journalBloc.changeWeight('1000');
                            }
                            updateText = true;
                          },
                        ),
                        Expanded(
                          child: AppTextField(
                            isIOS: Platform.isIOS,
                            hintText: 'Weight in kg?',
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
                              journalBloc.changeWeight(keyBoardEvent);
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
                              if (snapshot.data! <= 999) {
                                journalBloc
                                    .changeWeight('${snapshot.data! + 1}');
                              } else {
                                journalBloc.changeWeight('1');
                              }
                            } else {
                              journalBloc.changeWeight('1');
                            }
                            updateText = true;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        StreamBuilder<int>(
          stream: journalBloc.reps,
          builder: (context, snapshot) {
            return ReusableCard(
              backgroundColor: AppColours.forground,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'How many reps did you do?',
                    style: TextStyles.body,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
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
                                journalBloc.changeRep('${snapshot.data! - 1}');
                              } else {
                                journalBloc.changeRep('99');
                              }
                            } else {
                              journalBloc.changeRep('99');
                            }
                            updateText = true;
                          },
                        ),
                        Expanded(
                          child: AppTextField(
                            isIOS: Platform.isIOS,
                            hintText: 'Number of repetitions',
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
                              journalBloc.changeRep(keyBoardEvent);
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
                              if (snapshot.data! < 99) {
                                journalBloc.changeRep('${snapshot.data! + 1}');
                              } else {
                                journalBloc.changeRep('1');
                              }
                            } else {
                              journalBloc.changeRep('1');
                            }
                            updateText = true;
                          },
                        ),
                      ],
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

  //**************************************************************************\\
  Widget buildSubmitButton(BuildContext context, JournalingBloc journalBloc) {
    return StreamBuilder<bool>(
      stream: widget.exerciseType == 'aerobic'
          ? journalBloc.isAerobicValid
          : journalBloc.isStrengthValid,
      builder: (context, snapshot) {
        return AppButton(
          buttonText: 'Add',
          buttonType: (snapshot.data == false || snapshot.data == null)
              ? ButtonType.disabled
              : ButtonType.primary,
          onPressed: () {
            journalBloc.updateAExercise(
              sequence: widget.sequence,
              exerciseType: widget.exerciseType,
            );
            journalBloc.nullifyInputs();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
