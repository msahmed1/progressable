// import 'package:shared_preferences/shared_preferences.dart';
//
// class DataPersistence {
//   Future<String> getWeightUnit() async {
//     final prefs = await SharedPreferences.getInstance();
//     final unit = prefs.getString('weightUnit');
//     if (unit == null) {
//       return 'kg';
//     } else {
//       return unit;
//     }
//   }
//
//   Future<void> setWeightUnit(String unit) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('weightUnit', unit);
//   }
//
//   Future<String> getDistanceUnit() async {
//     final prefs = await SharedPreferences.getInstance();
//     final unit = prefs.getString('distanceUnit');
//     if (unit == null) {
//       return 'km';
//     } else
//       return unit;
//   }
//
//   Future<void> setDistanceUnit(String unit) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('distanceUnit', unit);
//   }
// }
