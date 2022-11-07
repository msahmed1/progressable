import 'dart:async';
import 'dart:io';

import 'package:exercise_journal/src/blocs/auth_bloc.dart';
import 'package:exercise_journal/src/blocs/workout_planning_bloc.dart';
import 'package:exercise_journal/src/models/workout_planning_template/a_workout.dart';
import 'package:exercise_journal/src/screens/on_boarding.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/widgets/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  //***************************** local variables *****************************\\
  static const String id = 'home_screen';

  //**************************************************************************\\
  //***************************** Constructor ********************************\\
  //**************************************************************************\\
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //***************************** local variables *****************************\\
  late StreamSubscription _userSubscription;

  //**************************************************************************\\
  //***************************** Constructor ********************************\\
  //**************************************************************************\\
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var authBloc = Provider.of<AuthBloc>(context, listen: false);
      _userSubscription = authBloc.user.listen((user) {
        if (user.userId == '') {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(OnBoarding.id, (route) => false);
        }
      });
    });
    super.initState();
  }

  //**************************************************************************\\
  //*************************** build Function *******************************\\
  //**************************************************************************\\
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);

    return StreamProvider<List<AWorkout>>.value(
      value: Provider.of<WorkoutPlanBloc>(context)
          .getAllWorkouts(authBloc.userID.toString()),
      initialData: const [],
      child: Platform.isIOS
          ? CupertinoPageScaffold(
              backgroundColor: AppColours.forground,
              child: NavBar.cupertinoTabScaffold,
            )
          : DefaultTabController(
              length: NavBar.tabBarLength,
              child: Scaffold(
                body: NavBar.materialTabBarView,
                bottomNavigationBar: NavBar.materialTabBar,
                backgroundColor: AppColours.forground,
              ),
            ),
      catchError: (_, __) => <AWorkout>[],
    );
  }

  //**************************************************************************\\
  //***************************** destructors ********************************\\
  //**************************************************************************\\
  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}
