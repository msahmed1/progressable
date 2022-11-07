import 'package:exercise_journal/src/styles/colours.dart';
import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RawMaterialButton(
        onPressed: onPressed,
        elevation: 0.0,
        constraints: const BoxConstraints.tightFor(
          width: 50.0,
          height: 50.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        fillColor: AppColours.secondaryButton,
        child: Icon(
          icon,
          size: 20.0,
          color: AppColours.buttonText,
        ),
      ),
    );
  }
}
