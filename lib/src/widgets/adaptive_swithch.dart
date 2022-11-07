import 'dart:io';

import 'package:exercise_journal/src/styles/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveSwitch extends StatelessWidget {
  final bool currentState;
  final Function onChange;

  const AdaptiveSwitch({
    super.key,
    required this.currentState,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        value: currentState,
        onChanged: (bool newState) => onChange(newState),
        thumbColor: AppColours.forground,
        activeColor: AppColours.primaryButton,
      );
    } else {
      return Switch(
        value: currentState,
        onChanged: (bool newState) => onChange(newState),
        activeTrackColor: AppColours.primaryButton,
        activeColor: AppColours.primaryButton,
        inactiveThumbColor: AppColours.forground,
      );
    }
  }
}
