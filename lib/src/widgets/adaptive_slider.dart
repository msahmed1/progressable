import 'dart:io';

import 'package:exercise_journal/src/styles/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveSlider extends StatelessWidget {
  final int value;
  final Function onChange;
  final double minVal;
  final double maxVal;
  final double initVal;
  final int divisions;

  const AdaptiveSlider({
    super.key,
    required this.value,
    required this.onChange,
    required this.maxVal,
    required this.minVal,
    required this.initVal,
    this.divisions = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: const EdgeInsets.all(6.0),
            child: CupertinoSlider(
              value: value == -1 ? initVal : value.toDouble(),
              min: minVal,
              max: maxVal,
              divisions: divisions,
              onChanged: (double newValue) =>
                  onChange((newValue.round()).toDouble()),
              activeColor: AppColours.secondaryButton,
              thumbColor: AppColours.primaryButton,
            ),
          )
        : SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColours.secondaryButton,
              thumbColor: AppColours.primaryButton,
              overlayColor: Colors.blueAccent.withOpacity(0.5),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
            ),
            child: Slider(
              value: value == -1 ? initVal : value.toDouble(),
              min: minVal,
              max: maxVal,
              divisions: divisions,
              inactiveColor: AppColours.disabled,
              onChanged: (double newValue) =>
                  onChange((newValue.round()).toDouble()),
            ),
          );
  }
}
