import 'package:flutter/material.dart';

abstract class AppColours {
  //Background colours
  static Color get background => const Color(0xFFE0E0E0);

  static Color get forground => const Color(0xFFEEEEEE);

  static Color get midground => const Color(0xFFF5F5F5);

  static Color get appBar => const Color(0xFFE0E0E0);

  // static Color get shadow2 => const Color(0xFF4E5b60);
  static Color get shadow => const Color(0xFF757575);

  //Text colours
  static Color get title => const Color(0xFF00838F);

  static Color get textBody => Colors.black54;

  static Color get suggestion => Colors.blueGrey;

  //Button colours
  static Color get primaryButton => const Color(0xFF00838F);

  static Color get secondaryButton => const Color(0xFF0097A7);

  static Color get tertiaryButton => const Color(0xFF4DD0E1);

  static Color get textButton => const Color(0xFF00838F);

  static Color get buttonText => const Color(0xFFECEFF1);

  static Color get disabled => Colors.grey;

  static Color get edit => const Color(0xFF388E3C);

  static Color get delete => const Color(0xFFF57C00);

  static Color get exit => const Color(0xFF263A44);

  //Alert colours
  static Color get error => Colors.red;

  static Color get warning => Colors.amberAccent;

  //App specific colours
  static Color get workout => Colors.red;

  static Color get warmUp => const Color.fromARGB(255, 244, 184, 0);

  static Color get coolDown => Colors.blue;

  static Color get open => Colors.blue;

  static Color get close => Colors.red;
}
