import 'dart:io';

import 'package:exercise_journal/src/styles/base.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciseTypeSelector extends StatelessWidget {
  // If no exercise type is selected the default will be saved as "workout" which is taken care of in workout_planning_bloc.dart
  final String value;

  final Function onChange;

  ExerciseTypeSelector({
    super.key,
    required this.value,
    required this.onChange,
  });

  final Map<int, Widget> workoutTypeWidgetText = <int, Widget>{
    0: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.invert_colors,
            size: 17.0,
            color: AppColours.warmUp,
          ),
          const SizedBox(
            width: 4.0,
          ),
          Text(
            "Warm Up",
            style: TextStyle(
              fontSize: 17,
              color: AppColours.warmUp,
            ),
          )
        ],
      ),
    ),
    1: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.whatshot,
            size: 17.0,
            color: AppColours.workout,
          ),
          const SizedBox(
            width: 4.0,
          ),
          Text(
            "Workout",
            style: TextStyle(
              fontSize: 17,
              color: AppColours.workout,
            ),
          )
        ],
      ),
    ),
    2: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.ac_unit,
            size: 17.0,
            color: AppColours.coolDown,
          ),
          const SizedBox(
            width: 4.0,
          ),
          Text(
            "Cool Down",
            style: TextStyle(
              fontSize: 17,
              color: AppColours.coolDown,
            ),
          )
        ],
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    List<bool> selectedWorkoutType = [false, true, false];
    int selectedValue = 1;
    if (value != '') {
      if (value == 'Warm Up') {
        selectedValue = 0;
        selectedWorkoutType = [true, false, false];
      } else if (value == 'Cool Down') {
        selectedValue = 2;
        selectedWorkoutType = [false, false, true];
      } else {
        selectedValue = 1;
        selectedWorkoutType = [false, true, false];
      }
    }
    // If "value" == '' then default values will be used

    final Map<int, String> exerciseTypes = {
      0: 'Warm Up',
      1: 'Workout',
      2: 'Cool Down'
    };

    return Platform.isIOS
        ? CupertinoSegmentedControl(
            groupValue: selectedValue,
            selectedColor: AppColours.primaryButton,
            unselectedColor: AppColours.midground,
            borderColor: AppColours.secondaryButton,
            onValueChanged: (int index) {
              selectedValue = index;
              onChange(exerciseTypes[index]);
            },
            children: workoutTypeWidgetText,
          )
        : Center(
            child: ToggleButtons(
              isSelected: selectedWorkoutType,
              onPressed: (int index) {
                for (int i = 0; i < selectedWorkoutType.length; i++) {
                  if (i == index) {
                    selectedWorkoutType[i] = true;
                  } else {
                    selectedWorkoutType[i] = false;
                  }
                }
                onChange(exerciseTypes[index]);
              },
              borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
              borderWidth: BaseStyles.borderWidths,
              borderColor: AppColours.primaryButton,
              selectedBorderColor: AppColours.secondaryButton,
              children: <Widget>[
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 36) / 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.invert_colors,
                        size: 17.0,
                        color: AppColours.warmUp,
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        "Warm up",
                        style: TextStyle(
                          color: AppColours.warmUp,
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 36) / 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.whatshot,
                        size: 17.0,
                        color: AppColours.workout,
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        "Workout",
                        style: TextStyle(
                          color: AppColours.workout,
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 36) / 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.ac_unit,
                        size: 17.0,
                        color: AppColours.coolDown,
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        "Cool Down",
                        style: TextStyle(
                          color: AppColours.coolDown,
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
