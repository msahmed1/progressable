import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/blocs/journaling_bloc.dart';
import 'package:exercise_journal/src/screens/summary_screen.dart';
// import 'package:exercise_journal/src/screens/summary_screen.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:exercise_journal/src/widgets/custom_alert_dialog.dart';
import 'package:exercise_journal/src/widgets/display_workouts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class StartWorkoutJournal extends StatefulWidget {
  //***************************** local variables *****************************\\
  static const String id = 'workout_journal';

  //**************************************************************************\\
  //***************************** Constructor ********************************\\
  //**************************************************************************\\
  const StartWorkoutJournal({super.key});

  @override
  State<StartWorkoutJournal> createState() => _StartWorkoutJournalState();
}

class _StartWorkoutJournalState extends State<StartWorkoutJournal> {
  late FToast fToast;
  Stopwatch timer = Stopwatch();

  //**************************************************************************\\
  //***************************** Constructor ********************************\\
  //**************************************************************************\\
  @override
  void initState() {
    super.initState();
    // JournalingBloc journalBloc =
    //     Provider.of<JournalingBloc>(context, listen: false);
    // journalBloc.substituteSaved.listen((saved) {
    //   if (saved == true) {
    //     _showToast("Substitute saved");
    //   } else {
    //     _showToast("Substitute not saved");
    //   }
    // });
    //
    // fToast = FToast();
    // fToast.init(context);
    timer.start();
  }

  //**************************************************************************\\
  //*************************** build Function *******************************\\
  //**************************************************************************\\
  @override
  Widget build(BuildContext context) {
    JournalingBloc journalBloc = Provider.of<JournalingBloc>(context);

    return StreamBuilder(
      stream: journalBloc.workoutName,
      builder: (BuildContext context, snapshot) {
        if (Platform.isIOS) {
          return WillPopScope(
            onWillPop: () async => !Navigator.of(context).userGestureInProgress,
            child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                leading: GestureDetector(
                  child: Icon(
                    CupertinoIcons.clear_thick,
                    color: AppColours.primaryButton,
                  ),
                  onTap: () => _onExitPressed(),
                ),
                middle: AutoSizeText(
                  snapshot.data == null ? '' : snapshot.data.toString(),
                  style: TextStyles.title,
                  maxLines: 1,
                ),
                backgroundColor: AppColours.appBar,
              ),
              // Sliver App bar
              child: SafeArea(
                child: Scaffold(
                  body: pageBody(journalBloc),
                  backgroundColor: AppColours.background,
                ),
              ),
            ),
          );
        }
        return WillPopScope(
          onWillPop: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) => CustomAlertDialog(
                title: "Exit",
                description: 'If you exit now your workout will not be saved',
                primaryButtonText: 'Stay',
                primaryButton: () {
                  Navigator.of(context).pop(false);
                },
                secondaryButtonText: 'Leave',
                secondaryButton: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                },
              ),
            );
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(FontAwesomeIcons.xmark),
                onPressed: () => _onExitPressed(),
              ),
              title: AutoSizeText(
                snapshot.data == null ? '' : snapshot.data.toString(),
                style: TextStyles.title,
                maxLines: 1,
              ),
              backgroundColor: AppColours.appBar,
            ),
            // Sliver App bar
            body: pageBody(journalBloc),
          ),
        );
      },
    );
  }

  //**************************************************************************\\
  //****************************** Functions *********************************\\
  //**************************************************************************\\
  Widget pageBody(JournalingBloc journalBloc) {
    return Column(
      children: [
        const Expanded(
          child: DisplayWorkout(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: AppButton(
            buttonText: 'Save',
            onPressed: () {
              _onSave(journalBloc);
            },
            buttonType: ButtonType.primary,
          ),
        )
      ],
    );
  }

  Future<dynamic> _onExitPressed() {
    return (Platform.isIOS)
        ? showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => showAlertDialog(context),
          )
        : showDialog(
            context: context,
            builder: (BuildContext context) => showAlertDialog(context),
          );
  }

  Future<dynamic> _onSave(JournalingBloc journalBloc) {
    return (Platform.isIOS)
        ? showCupertinoDialog(
            context: context,
            builder: (BuildContext context) =>
                showSaveDialog(context, journalBloc),
          )
        : showDialog(
            context: context,
            builder: (BuildContext context) =>
                showSaveDialog(context, journalBloc),
          );
  }

  //**************************************************************************\\
  //************************* Supporting Functions ****************************\\
  //**************************************************************************\\
  Widget showAlertDialog(BuildContext context) {
    return CustomAlertDialog(
      title: "Exit",
      description: 'If you exit now your workout will not be saved',
      primaryButtonText: 'Stay',
      primaryButton: () {
        Navigator.of(context).pop();
      },
      secondaryButtonText: 'Leave',
      secondaryButton: () {
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
      },
    );
  }

  Widget showSaveDialog(BuildContext context, JournalingBloc journalBloc) {
    return CustomAlertDialog(
      title: "Save",
      description: 'Would you like to save this workout?',
      secondaryButtonText: 'Go Back',
      secondaryButton: () {
        Navigator.of(context).pop();
      },
      primaryButtonText: 'Yes',
      primaryButton: () {
        journalBloc.saveJournal();
        journalBloc.nullifyInputs();
        timer.stop();
        final int elapsed = timer.elapsed.inSeconds;
        Navigator.of(context).pushNamed('${SummaryScreen.id}/$elapsed');
        // int count = 0;
        // Navigator.of(context).popUntil((_) => count++ >= 2);
      },
    );
  }

// void _showToast(String msg) {
//   final Widget toast = Container(
//     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(25.0),
//       color: AppColours.primaryButton,
//     ),
//     child: Text(
//       msg,
//       style: TextStyles.buttonText,
//     ),
//   );
//
//   SchedulerBinding.instance.addPostFrameCallback((_) {
//     fToast.showToast(
//       child: toast,
//       gravity: ToastGravity.CENTER,
//       toastDuration: const Duration(milliseconds: 800),
//     );
//   });
// }
}
