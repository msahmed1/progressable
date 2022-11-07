import 'package:exercise_journal/src/styles/base.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:flutter/material.dart';

abstract class TextFieldsStyles {
  static TextStyle get text => TextStyles.body;

  static TextStyle get placeHolder => TextStyles.suggestion;

  static TextAlign get textAlign => TextAlign.center;

  static Color get cursorColor => AppColours.title;

  static BoxDecoration get cupertinoDecoration {
    return BoxDecoration(
      color: AppColours.forground,
      border: Border.all(
        color: AppColours.primaryButton,
        width: BaseStyles.borderWidths,
      ),
      borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
    );
  }

  static BoxDecoration get cupertinoErrorDecoration {
    return BoxDecoration(
      color: AppColours.forground,
      border: Border.all(
        color: AppColours.error,
        width: BaseStyles.borderWidths,
      ),
      borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
    );
  }

  static InputDecoration materialDecoration(String hintText, String errorText) {
    return InputDecoration(
      fillColor: AppColours.forground,
      filled: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      hintText: hintText,
      hintStyle: TextFieldsStyles.placeHolder,
      border: InputBorder.none,
      errorText: errorText == '' ? null : errorText,
      errorStyle: TextStyles.error,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColours.primaryButton,
          width: BaseStyles.borderWidths,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(BaseStyles.borderRadius),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColours.primaryButton,
          width: BaseStyles.borderWidths,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(BaseStyles.borderRadius),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColours.primaryButton,
          width: BaseStyles.borderWidths,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(BaseStyles.borderRadius),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColours.error,
          width: BaseStyles.borderWidths,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(BaseStyles.borderRadius),
        ),
      ),
    );
  }
}
