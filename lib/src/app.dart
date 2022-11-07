import 'dart:io';

import 'package:exercise_journal/src/blocs/ad_mob_bloc.dart';
import 'package:exercise_journal/src/blocs/auth_bloc.dart';
import 'package:exercise_journal/src/blocs/journaling_bloc.dart';
import 'package:exercise_journal/src/blocs/workout_planning_bloc.dart';
import 'package:exercise_journal/src/routes.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final authBloc = AuthBloc();
final planingBloc = WorkoutPlanBloc();
final journalingBloc = JournalingBloc();
final adMobBloc = AdMobBloc();

class App extends StatefulWidget {
  //**************************************************************************\\
  //***************************** Constructor ********************************\\
  //**************************************************************************\\
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    // This app is designed only to work vertically, so we limit
    // orientations to portrait up and down.
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );

    return MultiProvider(
      providers: [
        Provider(create: (context) => authBloc),
        Provider(create: (context) => planingBloc),
        Provider(create: (context) => journalingBloc),
        Provider(create: (context) => adMobBloc),
      ],
      child: const PlatformApp(),
    );
  }

  @override
  void dispose() {
    authBloc.dispose();
    planingBloc.dispose();
    journalingBloc.dispose();
    super.dispose();
  }
}

class PlatformApp extends StatelessWidget {
  //**************************************************************************\\
  //***************************** Constructor ********************************\\
  //**************************************************************************\\
  const PlatformApp({super.key});

  //**************************************************************************\\
  //*************************** build Function *******************************\\
  //**************************************************************************\\
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        // home: homeController(context),
        onGenerateRoute: customCupertinoRoutes,
        theme: CupertinoThemeData(
          scaffoldBackgroundColor: AppColours.background,
          barBackgroundColor: AppColours.appBar,
        ),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: homeController(context),
        onGenerateRoute: customMaterialRoutes,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColours.background,
          appBarTheme: AppBarTheme(
            color: AppColours.appBar,
            iconTheme: IconThemeData(
              color: AppColours.primaryButton,
            ),
          ),
        ),
      );
    }
  }
}
