//import 'package:flutter/foundation.dart';
//import 'package:success_program/src/services/shared_preferences.dart';
//
//class AppSettingsBloc extends ChangeNotifier {
//  final DataPersistence _localData = DataPersistence();
//
//  String _weightUnit;
//  String _distanceUnit;
//
//  AppSettingsBloc() {
//    loadAppSettings();
//  }
//
//  // Get
//  String get weightUnit => _weightUnit;
//  String get distanceUnit => _distanceUnit;
//
//  loadAppSettings() async {
//    _weightUnit = await _localData.getWeightUnit();
//    _distanceUnit = await _localData.getDistanceUnit();
//    notifyListeners(); //Call notifier as app might build before data retrieved, so need to make sure stored values used
//  }
//
//  // setter
//  setWeightUnitType(String unit) async {
//    await _localData.setWeightUnit(unit);
//    _weightUnit = unit;
//    notifyListeners();
//  }
//
//  // setter
//  setDistanceUnitType(String unit) async {
//    await _localData.setDistanceUnit(unit);
//    _distanceUnit = unit;
//    notifyListeners();
//  }
//}
