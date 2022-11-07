import 'dart:io';

import 'package:exercise_journal/src/app.dart';
import 'package:exercise_journal/src/blocs/auth_bloc.dart';
import 'package:exercise_journal/src/styles/base.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  static const String id = 'settings';

  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final Map<int, String> weightUnits = const <int, String>{0: 'kg', 1: 'lb'};

  final Map<int, Widget> weightUnitsWidgetText = const <int, Widget>{
    0: Text('kg'),
    1: Text('lb'),
  };

  @override
  Widget build(BuildContext context) {
    AuthBloc appSettings = Provider.of<AuthBloc>(context);

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'Settings',
            style: TextStyles.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: AppColours.appBar,
        ),
        child: SafeArea(child: pageBody(context, appSettings)),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyles.title,
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColours.appBar,
      ),
      body: SafeArea(child: pageBody(context, appSettings)),
    );
  }

  Widget pageBody(BuildContext context, AuthBloc appSettings) {
    List<bool> selectedWeightUnit = [true, false];
    int theirGroupValue = 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder<String>(
          stream: appSettings.weightUnitType,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == 'kg') {
                selectedWeightUnit = [true, false];
                theirGroupValue = 0;
              } else {
                selectedWeightUnit = [false, true];
                theirGroupValue = 1;
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10.0),
                if (Platform.isIOS)
                  CupertinoSegmentedControl(
                    groupValue: theirGroupValue,
                    onValueChanged: (int index) {
                      theirGroupValue = index;
                      authBloc.changeWeightUnitType(
                        weightUnits[index].toString(),
                      );
                    },
                    children: weightUnitsWidgetText,
                  )
                else
                  ToggleButtons(
                    isSelected: selectedWeightUnit,
                    onPressed: (int index) {
                      for (int i = 0; i < selectedWeightUnit.length; i++) {
                        if (i == index) {
                          selectedWeightUnit[i] = true;
                        } else {
                          selectedWeightUnit[i] = false;
                        }
                      }
                      authBloc.changeWeightUnitType(
                        weightUnits[index].toString(),
                      );
                    },
                    borderRadius:
                        BorderRadius.circular(BaseStyles.borderRadius),
                    borderWidth: BaseStyles.borderWidths,
                    borderColor: AppColours.primaryButton,
                    selectedBorderColor: AppColours.primaryButton,
                    children: const <Widget>[
                      Text('kg'),
                      Text('lb'),
                    ],
                  )
              ],
            );
          },
        ),
        AppButton(
          buttonText: 'Save',
          buttonType: ButtonType.primary,
          onPressed: () {
            authBloc.saveUserSettings();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
