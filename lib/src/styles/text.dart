import 'package:exercise_journal/src/styles/colours.dart';
import 'package:flutter/material.dart';

abstract class TextStyles {
  static TextStyle get title {
    return TextStyle(
      color: AppColours.title,
      fontWeight: FontWeight.bold,
      fontSize: 26.0,
    );
  }

  static TextStyle get subTitle {
    return const TextStyle(
      color: Colors.blueGrey,
      fontSize: 12.0,
    );
  }

  static TextStyle get body {
    return TextStyle(
      color: AppColours.textBody,
      fontSize: 18.0,
    );
  }

  static TextStyle get cardTitle {
    return TextStyle(
      color: AppColours.textBody,
      fontSize: 18.0,
    );
  }

  static TextStyle get cardBody {
    return TextStyle(
      color: AppColours.suggestion,
      fontSize: 14.0,
    );
  }

  static TextStyle get buttonText {
    return TextStyle(
      fontSize: 20,
      color: AppColours.buttonText,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle get textButton {
    return TextStyle(
      fontSize: 20,
      color: AppColours.textButton,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle get cupertinoPicker {
    return TextStyle(
      fontSize: 30.0,
      color: AppColours.textBody,
    );
  }

  static TextStyle get suggestion {
    return TextStyle(
      color: AppColours.suggestion,
      fontSize: 16.0,
    );
  }

  static TextStyle get error {
    return TextStyle(
      color: AppColours.error,
      fontSize: 12.0,
    );
  }

  static TextStyle get bodyLightBlue {
    return const TextStyle(
      color: Colors.lightBlue,
    );
  }

  static TextStyle get bodyRed {
    return const TextStyle(
      color: Colors.red,
    );
  }
}
