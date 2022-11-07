// import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String userId;
  final String email;
  final String userName;
  final DateTime? lastActive;

  double height;
  double weight;
  int age;

  String weightUnit;
  String distanceUnit;

  final bool verified;

  int workoutLimiter = 3;
  int substituteExerciseLimiter = 2;
  int exerciseLimiter = 5;
  String userType; //I can remove this

  //Account type
  bool? premium;
  bool? unlimited;

  //TODO: add int dataStructureVersion = 1;

  UserData({
    this.userName = '',
    this.email = '',
    this.lastActive,
    this.height = 0.0,
    this.weight = 0.0,
    this.age = 0,
    required this.userId,
    this.weightUnit = 'kg',
    this.distanceUnit = 'm',
    required this.verified,
    required this.workoutLimiter,
    required this.substituteExerciseLimiter,
    required this.exerciseLimiter,
    this.userType = 'standard',
    this.premium,
    this.unlimited,
  });

  //Since data is stored in JSON we need methods to transform to and from JSON

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'lastActive': lastActive,
      'email': email,
      'height': height,
      'weight': weight,
      'age': age,
      'weightUnit': weightUnit,
      'distanceUnit': distanceUnit,
      'verified': verified,
      'workoutLimiter': workoutLimiter,
      'substituteExerciseLimiter': substituteExerciseLimiter,
      'exerciseLimiter': exerciseLimiter,
      'userType': userType,
      'premium': premium,
      'unlimited': unlimited,
    };
  }

  factory UserData.fromFirestore(Map<String, dynamic> firestore) {
    if (firestore.isEmpty) {
      return UserData(
          userId: '',
          weightUnit: '',
          distanceUnit: '',
          verified: false,
          workoutLimiter: 3,
          substituteExerciseLimiter: 2,
          exerciseLimiter: 5,
          premium: firestore['premium'] as bool,
          unlimited: firestore['unlimited'] as bool,
          lastActive: DateTime.now());
    }

    //I don't need this but its here for reference in case I come across a similar problem in the future.
    // if (firestore['workoutCount'] == null || firestore['userType'] == null) {
    //   return UserData(
    //     userName: firestore['userName'] as String,
    //     userId: firestore['userId'] as String,
    //     email: firestore['email'] as String,
    //     height: firestore['height'] as double,
    //     weight: firestore['weight'] as double,
    //     age: firestore['age'] as int,
    //     weightUnit: firestore['weightUnit'] as String,
    //     distanceUnit: firestore['distanceUnit'] as String,
    //     verified: firestore['verified'] as bool,
    //     workoutLimiter: 3,
    //     substituteExerciseLimiter: 2,
    //     exerciseLimiter: 5,
    //     premium: firestore['premium'] as bool,
    //     unlimited: firestore['unlimited'] as bool,
    //   );
    // }

    return UserData(
      userName: firestore['userName'] as String,
      userId: firestore['userId'] as String,
      email: firestore['email'] as String,
      lastActive: firestore['lastActive'] == null
          ? DateTime.parse('2022-09-15 20:18:04Z')
          : (firestore['lastActive'] as Timestamp).toDate(),
      height: (firestore['height'] as num).toDouble(),
      weight: (firestore['weight'] as num).toDouble(),
      age: firestore['age'] as int,
      weightUnit: firestore['weightUnit'] as String,
      distanceUnit: firestore['distanceUnit'] as String,
      verified: firestore['verified'] as bool,
      workoutLimiter: firestore['workoutLimiter'] as int,
      substituteExerciseLimiter: firestore['substituteExerciseLimiter'] as int,
      userType: firestore['userType'] as String,
      exerciseLimiter: firestore['exerciseLimiter'] as int,
      premium:
          firestore['premium'] != null ? firestore['premium'] as bool : false,
      unlimited: firestore['unlimited'] != null
          ? firestore['unlimited'] as bool
          : false,
    );
  }
}
