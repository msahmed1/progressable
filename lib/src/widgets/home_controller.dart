import 'package:exercise_journal/src/app.dart';
import 'package:exercise_journal/src/models/user.dart';
import 'package:exercise_journal/src/screens/await_verification.dart';
import 'package:exercise_journal/src/screens/home_view.dart';
import 'package:exercise_journal/src/screens/on_boarding.dart';
import 'package:exercise_journal/src/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeController extends StatelessWidget {
  const HomeController({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
      stream: authBloc.user,
      initialData: UserData(
        userId: 'placeholder',
        email: 'placeholder',
        verified: true,
        workoutLimiter: 0,
        substituteExerciseLimiter: 0,
        exerciseLimiter: 0,
        lastActive: DateTime.now(),
      ),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const LoadingIndicator(
            text:
                'setting up app, please ensure you have a stable internet connection',
          );
        } else if (snapshot.data!.userId == '' ||
            snapshot.data!.userId == 'placeholder') {
          return const OnBoarding();
        } else if (snapshot.data!.verified == false) {
          return AwaitingVerification(email: snapshot.data!.email);
        } else {
          return const Home();
        }
      },
    );
  }
}
