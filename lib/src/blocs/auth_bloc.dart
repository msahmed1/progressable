import 'dart:async';
import 'dart:math';

import 'package:exercise_journal/src/blocs/in_app_purchase_bloc.dart';
import 'package:exercise_journal/src/models/user.dart';
import 'package:exercise_journal/src/services/auth_service.dart';
import 'package:exercise_journal/src/services/firestore_user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:rxdart/rxdart.dart';

final RegExp regExpEmail = RegExp(
  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
);

class AuthBloc {
  Timer? timer;
  final AuthService _authService = AuthService();
  final IAPBloc _iapBloc = IAPBloc();

  // final googleSignIn = GoogleSignIn(scopes: ['email']);
  final _dbService = FirestoreService();

  // Behaviour subjects cache the last values you pass into the stream
  final _email = BehaviorSubject<String?>();
  final _confirmEmail = BehaviorSubject<String?>();
  final _password = BehaviorSubject<String?>();
  final _confirmPassword = BehaviorSubject<String?>();
  final _name = BehaviorSubject<String?>();
  final _user = BehaviorSubject<UserData>();
  final _errorMessage = BehaviorSubject<String>();
  final _confirmationCode = BehaviorSubject<String>();
  final _processRunning = BehaviorSubject<bool>();
  final _showConfirmationDialog = BehaviorSubject<bool>();
  final _showAutomatedConfirmationDialog = BehaviorSubject<bool>();
  final _emailVerified = BehaviorSubject<bool>();
  final _uid = BehaviorSubject<String>();
  final _workoutLimiter = BehaviorSubject<int>();
  final _substituteExerciseLimiter = BehaviorSubject<int>();
  final _exerciseLimiter = BehaviorSubject<int>();

  final _gender = BehaviorSubject<String>();
  final _height = BehaviorSubject<String>();
  final _weight = BehaviorSubject<String>();
  final _age = BehaviorSubject<int>();
  final _weightUnitType = BehaviorSubject<String>();
  final _distanceUnitType = BehaviorSubject<String>();
  final _bmiResult = BehaviorSubject<String>();

  final _premium = BehaviorSubject<bool>();

  final _unlimited = BehaviorSubject<bool>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Constructor
  AuthBloc() {
    _authService.currentUser().listen((user) {
      if (user != null) {
        setUser(user.uid);
        _email.sink.add(user.email.toString());
        _name.sink.add(user.displayName.toString());
        _uid.sink.add(user.uid);
        _iapBloc.changeUID(user.uid);

        // Can't get user data without having the current user ID. So listener is call within listener
        _dbService.getUserData(user.uid)?.listen((userData) {
          if (userData != null) {
            _premium.sink.add(userData.premium ?? false);
            _unlimited.sink.add(userData.unlimited ?? false);
          } else {
            _premium.sink.add(false);
            _unlimited.sink.add(false);
          }
        });
      } else {
        setUser('');
      }
    });
  }

  // Get Data
  Stream<String> get email => _email.stream.transform(validateEmail);

  Stream<String?> get confirmEmail =>
      _confirmEmail.stream.doOnData((emailToCompare) {
        if (emailToCompare?.compareTo(_email.value!) != 0) {
          _confirmEmail.sink.addError('Must match email');
        }
      });

  Stream<String> get password => _password.stream.transform(validatePassword);

  Stream<String> get name => _name.stream.transform(validateName);

  Stream<bool> get emailVerified => _emailVerified.stream;

  Stream<String?> get confirmPassword =>
      _confirmPassword.stream.doOnData((passwordToCompare) {
        if (passwordToCompare?.compareTo(_password.value!) != 0) {
          _confirmPassword.sink.addError('Must match password');
        }
      });

  Stream<bool> get isEmailSignupValid => CombineLatestStream.combine4(
        email,
        confirmEmail,
        password,
        confirmPassword,
        (email, confirmEmail, password, confirmPassword) =>
            password == confirmPassword && email == confirmEmail,
      );

  Stream<bool> get isEmailSignInValid =>
      CombineLatestStream.combine2(email, password, (email, password) => true);

  Stream<String> get uid => _uid.stream;

  Stream<bool> get isVerifyValid =>
      CombineLatestStream.combine2(email, name, (email, name) => true);

  Stream<String> get accountType =>
      CombineLatestStream.combine2(premium, unlimited, (premium, unlimited) {
        if (unlimited == true) {
          return 'Unlimited';
        } else if (premium == true) {
          return 'Premium';
        }
        return 'Free';
      });

  Stream<bool> get isBMIValid =>
      CombineLatestStream.combine2(height, weight, (height, weight) => true);

  Stream<UserData> get user => _user.stream;

  Stream<String> get errorMessage => _errorMessage.stream;

  Future<String> get getCurrentUID async => (_auth.currentUser)!.uid;

  String? get userID => _user.value.userId;

  Stream<String> get confirmationCode => _confirmationCode.stream;

  Stream<bool> get processRunning => _processRunning.stream;

  Stream<bool> get showConfirmationDialog => _showConfirmationDialog;

  Stream<bool> get showAutomatedConfirmationDialog =>
      _showAutomatedConfirmationDialog;

  Stream<String> get gender => _gender.stream;

  Stream<double> get height => _height.stream.transform(validateHeight);

  final validateHeight = StreamTransformer<String, double>.fromHandlers(
    handleData: (bodyWeight, sink) {
      if (bodyWeight != '') {
        try {
          if (bodyWeight.contains('.')) {
            if (bodyWeight.split('.')[1].length > 2) {
              sink.addError("Enter a valid number to 2 decimal places");
            } else if (double.parse(bodyWeight) > 220.0) {
              sink.addError("Weight must be less than 220cm");
            } else if (double.parse(bodyWeight) < 120.0) {
              sink.addError("Weight must be greater than 120cm");
            } else {
              //I will probably have to do some error checking here as sometimes the conversation from double to string fails
              sink.add(double.parse(bodyWeight));
            }
          } else if (double.parse(bodyWeight) > 220.0) {
            sink.addError("Weight must be less than 220cm");
          } else if (double.parse(bodyWeight) < 120.0) {
            sink.addError("Weight must be greater than 120cm");
          } else {
            sink.add(double.parse(bodyWeight));
          }
        } catch (error) {
          sink.add(0);
          sink.addError('Enter a valid number');
        }
      }
    },
  );

  Stream<double> get weight => _weight.stream.transform(validateWeight);

  final validateWeight = StreamTransformer<String, double>.fromHandlers(
    handleData: (bodyWeight, sink) {
      if (bodyWeight != '') {
        try {
          if (bodyWeight.contains('.')) {
            if (bodyWeight.split('.')[1].length > 2) {
              sink.addError("Enter a valid number to 2 decimal places");
            } else if (double.parse(bodyWeight) > 200.0) {
              sink.addError("Weight must be less than 200kg");
            } else if (double.parse(bodyWeight) < 40.0) {
              sink.addError("Weight must be greater than 40kg");
            } else {
              //I will probably have to do some error checking here as sometimes the conversation from double to string fails
              sink.add(double.parse(bodyWeight));
            }
          } else if (double.parse(bodyWeight) > 200.0) {
            sink.addError("Weight must be less than 200kg");
          } else if (double.parse(bodyWeight) < 40) {
            sink.addError("Weight must be greater than 40kg");
          } else {
            sink.add(double.parse(bodyWeight));
          }
        } catch (error) {
          sink.add(0);
          sink.addError('Enter a valid number');
        }
      }
    },
  );

  Stream<int> get age => _age.stream.transform(validateAge);

  Stream<String> get weightUnitType => _weightUnitType.stream;

  Stream<String> get distanceUnitType => _distanceUnitType.stream;

  Stream<String> get bmiResult => _bmiResult.stream;

  Stream<bool> get calcBmi =>
      CombineLatestStream.combine2(height, weight, (email, password) => true);

  Stream<int> get workoutLimiter => _workoutLimiter.stream;

  Stream<int> get substituteExerciseLimiter =>
      _substituteExerciseLimiter.stream;

  Stream<int> get exerciseLimiter => _exerciseLimiter.stream;

  Stream<bool> get premium => _premium.stream;

  Stream<bool> get unlimited => _unlimited.stream;

  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changeConfirmEmail => _confirmEmail.sink.add;

  Function(String) get changePassword => _password.sink.add;

  Function(String) get changedName => _name.sink.add;

  Function(String) get changeConfirmPassword => _confirmPassword.sink.add;

  Function(String) get changeConfirmationCode => _confirmationCode.sink.add;

  Function(bool) get changeShowAutomatedConfirmationDialog =>
      _showAutomatedConfirmationDialog.sink.add;

  Function(String) get changeGender => _gender.sink.add;

  Function(String) get changeHeight => _height.sink.add;

  Function(String) get changeWeight => _weight.sink.add;

  Function(int) get changeAge => _age.sink.add;

  Function(String) get changeWeightUnitType => _weightUnitType.sink.add;

  Function(String) get changeDistanceUnitType => _distanceUnitType.sink.add;

  Future<void> setUser(String userId) async {
    if (userId != '') {
      final UserData user =
          await _dbService.getUser(userId); //.getUser() used for auto-login
      _user.sink.add(user);
      _workoutLimiter.sink.add(user.workoutLimiter);
      _substituteExerciseLimiter.sink.add(user.substituteExerciseLimiter);
      _exerciseLimiter.sink.add(user.exerciseLimiter);
      _emailVerified.sink.add(user.verified);
      _premium.sink.add(user.premium ?? false);
      _unlimited.sink.add(user.unlimited ?? false);
    } else {
      _user.sink.add(
        UserData(
          userId: '',
          verified: false,
          workoutLimiter: 4,
          substituteExerciseLimiter: 2,
          exerciseLimiter: 5,
          lastActive: DateTime.now(),
        ),
      );
      _workoutLimiter.sink.add(3);
      _substituteExerciseLimiter.sink.add(2);
      _exerciseLimiter.sink.add(5);
    }
  }

  // Validators
  final validateEmail = StreamTransformer<String?, String>.fromHandlers(
    handleData: (email, sink) {
      if (email != null) {
        if (email == '') {
          sink.addError('A email is required');
        } else if (regExpEmail.hasMatch(email.trim())) {
          sink.add(email.trim());
        } else {
          sink.addError('Valid Email Required');
        }
      }
    },
  );

  final validatePassword = StreamTransformer<String?, String>.fromHandlers(
    handleData: (password, sink) {
      if (password != null) {
        if (password == '') {
          sink.addError('Password is required');
        } else if (password.length >= 8) {
          sink.add(password.trim());
        } else {
          sink.addError('8 Character Minimum');
        }
      }
    },
  );

  final validateName = StreamTransformer<String?, String>.fromHandlers(
    handleData: (name, sink) {
      if (name != null) {
        if (name != '') {
          sink.add(name.trim());
        } else {
          sink.addError("can't be left empty");
        }
      }
    },
  );

  final validateAge = StreamTransformer<int, int>.fromHandlers(
    handleData: (userAge, sink) {
      if (userAge != 0) {
        if (userAge >= 100) {
          sink.add(16);
        } else if (userAge < 1) {
          sink.add(100);
        } else {
          sink.add(userAge);
        }
      }
    },
  );

  //Functions
  void dispose() {
    _email.close();
    _confirmEmail.close();
    _emailVerified.close();
    _password.close();
    _confirmPassword.close();
    _name.close();
    _user.close();
    _errorMessage.close();
    _gender.close();
    _height.close();
    _weight.close();
    _age.close();
    _weightUnitType.close();
    _distanceUnitType.close();
    _bmiResult.close();
    _showConfirmationDialog.close();
    _showAutomatedConfirmationDialog.close();
    timer!.cancel();
    _processRunning.close();
    _confirmationCode.close();
    _workoutLimiter.close();
    _substituteExerciseLimiter.close();
    _exerciseLimiter.close();
  }

  void clearValues() {
    changedName('');
    changeEmail('');
    changeConfirmEmail('');
    changePassword('');
    changeConfirmPassword('');
    _errorMessage.sink.add('');
    _confirmationCode.sink.add('');
  }

  void clearErrorMessage() {
    _errorMessage.sink.add('');
  }

  // Email sign in
  Future<void> signInEmail() async {
    try {
      //Mark Process as Running
      _processRunning.sink.add(true);

      //Create Firebase Auth Record
      await _authService.signInEmail(_email.value!, _password.value!);
      final user = _authService.user();
      if (user != null) {
        await user
            .reload(); // verifyEmail does not reload by itself so need to do it manually
        if (user.emailVerified) {
          _emailVerified.sink.add(true);
          _dbService.updateEmailVerified(
            userId: user.uid,
            verified: user.emailVerified,
          );
        } else {
          verifyEmail();
        }
      }
      //Mark Process as Stopped
      _processRunning.sink.add(false);
    } on FirebaseAuthException catch (error) {
      _processRunning.sink.add(false);
      _errorMessage.sink.add(error.message.toString());
    } catch (error) {
      _processRunning.sink.add(false);
      _errorMessage.sink.add(error.toString());
    }
  }

  // Email sign up
  Future<void> signUpEmail() async {
    final String? name = _name.value;

    try {
      //Mark Process as Running
      _processRunning.sink.add(true);

      //Create Firebase Auth Record
      final UserCredential authResult =
          await _authService.signupEmail(_email.value!, _password.value!);

      final user = UserData(
        userName: name ?? '',
        // For some reason if I put _name.value.trim() in the object is save as null, therefore I created a variable to store the value
        userId: authResult.user!.uid,
        email: _email.value!,
        verified: false,
        workoutLimiter: 4,
        substituteExerciseLimiter: 2,
        exerciseLimiter: 5,
        lastActive: DateTime.now(),
      );
      await _dbService.setUser(user);
      verifyEmail();

      //Mark Process as Stopped
      _processRunning.sink.add(false);
    } on FirebaseAuthException catch (error) {
      _processRunning.sink.add(false);
      _errorMessage.sink.add(error.message.toString());
      if (error.code == 'weak-password') {
      } else if (error.code == 'email-already-in-use') {}
    } catch (error) {
      _processRunning.sink.add(false);
      _errorMessage.sink.add(error.toString());
    }
  }

  Future<void> verifyEmail() async {
    // Send verification email
    _authService.verifyEmail();

    // Start timer. Re-check user clicked verification link every 5 seconds
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final user = _authService.user();
      if (user != null) {
        await user
            .reload(); // verifyEmail does not reload by itself so need to do it manually
        if (user.emailVerified) {
          _emailVerified.sink.add(true);
          _dbService.updateEmailVerified(
            userId: user.uid,
            verified: user.emailVerified,
          );
          timer.cancel();
        }
      }
      // After 10 minutes stop checking
      else if (timer.tick > 600) {
        //Timeout
        timer.cancel();
        // Display a verification failed message
      }
    });
  }

  // Google sign in
  // signinGoogle() async {
  //
  //   try {
  //     final GoogleSignInAccount googleUser = await googleSignin.signIn();
  //     final GoogleSignInAuthentication googleAuth =
  //     await googleUser.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //         idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
  //     _processRunning.sink.add(true);
  //     await signinWithCredential(credential);
  //
  //     _processRunning.sink.add(false);
  //   } on PlatformException catch (error) {
  //     _processRunning.sink.add(false);
  //     _errorMessage.sink.add(error.message);
  //   } on FirebaseAuthException catch (error) {
  //     _processRunning.sink.add(false);
  //     _errorMessage.sink.add(error.message);
  //   }
  // }

//  Future updateUserName(String name, User currentUser) async {
//    var userUpdateInfo = UserUpdateInfo();
//    userUpdateInfo.displayName = name;
//    await currentUser.updateProfile(userUpdateInfo);
//    await currentUser.reload();
//  }

  // signinApple() async {
  //   if (!await AppleSignIn.isAvailable()) {
  //     _errorMessage.sink.add('This Device is not eligible for Apple Sign in');
  //     return null; //Break from the program
  //   }
  //
  //   final res = await AppleSignIn.performRequests([
  //     AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  //   ]);
  //
  //   _processRunning.sink.add(true);
  //
  //   switch (res.status) {
  //     case AuthorizationStatus.authorized:
  //       try {
  //         //Get Token
  //         final AppleIdCredential appleIdCredential = res.credential;
  //         final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
  //         final credential = oAuthProvider.credential(
  //             idToken: String.fromCharCodes(appleIdCredential.identityToken),
  //             accessToken:
  //             String.fromCharCodes(appleIdCredential.authorizationCode));
  //
  //         await signinWithCredential(credential);
  //
  //         _processRunning.sink.add(false);
  //       } on PlatformException catch (error) {
  //         _processRunning.sink.add(false);
  //         _errorMessage.sink.add(error.message);
  //       } on FirebaseAuthException catch (error) {
  //         _processRunning.sink.add(false);
  //         _errorMessage.sink.add(error.message);
  //       }
  //       break;
  //     case AuthorizationStatus.error:
  //       _processRunning.sink.add(false);
  //       _errorMessage.sink.add('Apple authorization failed');
  //       break;
  //     case AuthorizationStatus.cancelled:
  //       _processRunning.sink.add(false);
  //       break;
  //   }
  // }

  // Sign out

  Future<void> signOut() async {
    await _auth.signOut();
    _user.sink.add(
      UserData(
        userId: '',
        verified: false,
        workoutLimiter: 4,
        substituteExerciseLimiter: 2,
        exerciseLimiter: 5,
        lastActive: DateTime.now(),
      ),
    );
  }

  // Restart password
  Future<void> sendPasswordRestartEmail() async {
    _auth.sendPasswordResetEmail(email: _email.value!);
    _errorMessage.sink
        .add('A password reset link has been sent to ${_email.value}');
  }

  // Future<bool> isLoggedIn() async {
  //   // check if user has an account with us
  //   var firebaseUser = _auth.currentUser;
  //   if (firebaseUser == null) return false;
  //
  //   // check if they have a record in the database
  //   UserData user = await _dbService
  //       .getUser(firebaseUser.uid)
  //       .catchError((error) => print('isLoggedIn Firestore Error: $error'));
  //   if (user == null) return false;
  //
  //   _user.sink.add(user);
  //   _name.sink.add(user.userName);
  //   _email.sink.add(user.email);
  //   _age.sink.add(user.age);
  //   _gender.sink.add(user.gender);
  //   _height.sink.add(user.height);
  //   _weight.sink.add(user.weight);
  //   _weightUnitType.sink.add(user.weightUnit);
  //   _distanceUnitType.sink.add(user.distanceUnit);
  //   return true;
  // }

  // Future<void> signInWithCredential(AuthCredential credential,
  //     {bool verified = true,}) async {
  //   //Sign in to Firebase
  //   final result = await _authService.signInWithCredential(credential);
  //   //Check for existing user, Add if not yet registered
  //   final user = await _dbService.getUser(result.user!.uid);
  //   if (user.userId == '') {
  //     //Create App Database User
  //     final authyUser = UserData(
  //       email: result.user!.email.toString(),
  //       userId: result.user!.uid,
  //       verified: verified,
  //       workoutLimiter: 4,
  //       substituteExerciseLimiter: 2,
  //       exerciseLimiter: 5,
  //     );
  //     await _dbService.setUser(authyUser);
  //   }
  //
  //   setUser(result.user!.uid);
  // }

  Future<void> deleteUserAccount() async {
    try {
      //Mark Process as Running
      _processRunning.sink.add(true);

      //Delete Firebase Auth Record
      final UserCredential? reAuthenticated = await _authService
          .reauthenticateWithCredential(_email.value!, _password.value!);
      if (reAuthenticated != null) {
        _dbService.deleteUser(userId: reAuthenticated.user?.uid ?? '');
        await reAuthenticated.user?.delete();
      }

      //Mark Process as Stopped
      _processRunning.sink.add(false);
    } on FirebaseAuthException catch (error) {
      _processRunning.sink.add(false);
      _errorMessage.sink.add(error.message.toString());
    } catch (error) {
      _processRunning.sink.add(false);
      _errorMessage.sink.add(error.toString());
    }
  }

  Future<void> saveHealthData() async {
    await _dbService.updateHealthData(
      userId: _user.value.userId,
      height: double.parse(_height.value),
      weight: double.parse(_weight.value),
      age: _age.value,
    );
  }

  Future<void> saveUserSettings() async {
    final UserData user = UserData(
      userId: _user.value.userId,
      userName: _user.value.userName,
      email: _user.value.email,
      age: _age.value,
      height: double.parse(_height.value),
      weight: double.parse(_weight.value),
      verified: _emailVerified.value,
      workoutLimiter: 4,
      substituteExerciseLimiter: 2,
      exerciseLimiter: 5,
      lastActive: DateTime.now(),
    );
    await _dbService.setUser(user);
  }

  String calculateBMI() {
    if (_weight.hasValue && _height.hasValue) {
      double bmi = 0;
      try {
        bmi = (double.parse(_weight.value)) /
            pow((double.parse(_height.value)) / 100, 2);
      } catch (error) {
        bmi = 0;
      }
      return bmi.toStringAsFixed(1);
    }
    return 'Enter height and weight';
  }
}
