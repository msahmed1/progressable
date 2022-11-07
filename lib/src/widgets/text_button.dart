import 'dart:io';

import 'package:exercise_journal/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlainTextButton extends StatefulWidget {
  final String buttonText;
  final void Function() onPressed;

  const PlainTextButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  State<PlainTextButton> createState() => _PlainTextButtonState();
}

class _PlainTextButtonState extends State<PlainTextButton> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoButton(
        child: Text(
          widget.buttonText,
          style: TextStyles.textButton,
        ),
        onPressed: () => widget.onPressed(),
      );
    } else {
      return TextButton(
        child: Text(
          widget.buttonText,
          style: TextStyles.textButton,
        ),
        onPressed: () => widget.onPressed(),
      );
    }
  }
}
