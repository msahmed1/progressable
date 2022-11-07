import 'package:exercise_journal/src/styles/colours.dart';
import 'package:flutter/material.dart';

abstract class BaseStyles {
  static double get borderRadius => 10.0;

  static double get borderWidths => 2.0;

  static double get listFieldHorizontal => 14.0;

  static double get listFieldVertical => 5.0;

  static double get animationOffset => 2.0;

  static EdgeInsets get listPadding {
    return EdgeInsets.symmetric(
      horizontal: listFieldHorizontal,
      vertical: listFieldVertical,
    );
  }

  static List<BoxShadow> get boxShadow {
    return [
      BoxShadow(
        color: AppColours.shadow.withOpacity(0.5),
        offset: const Offset(1.0, 2.0),
        blurRadius: 2.0,
      )
    ];
  }

  static List<BoxShadow> get boxShadowPressed {
    return [
      BoxShadow(
        color: AppColours.shadow.withOpacity(0.5),
        offset: const Offset(1.0, 1.0),
        blurRadius: 1.0,
      )
    ];
  }

  static List<BoxShadow> get cardShadow {
    return [
      BoxShadow(
        color: AppColours.shadow.withOpacity(0.4),
        offset: const Offset(2.0, 2.0),
        blurRadius: 7.0,
        spreadRadius: 1.0,
      ),
      const BoxShadow(
        color: Colors.white,
        offset: Offset(-2.0, -2.0),
        blurRadius: 7.0,
        spreadRadius: 1.0,
      ),
    ];
  }

  static List<BoxShadow> get imageShadow {
    return const [
      BoxShadow(
        color: Colors.grey,
        offset: Offset(4.0, 4.0),
        blurRadius: 15.0,
        spreadRadius: 1.0,
      ),
      BoxShadow(
        color: Colors.white,
        offset: Offset(-4.0, -4.0),
        blurRadius: 15.0,
        spreadRadius: 1.0,
      ),
    ];
  }
}
