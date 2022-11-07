import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/blocs/auth_bloc.dart';
import 'package:exercise_journal/src/blocs/journaling_bloc.dart';
import 'package:exercise_journal/src/blocs/workout_planning_bloc.dart';
import 'package:exercise_journal/src/models/workout_planning_template/a_workout.dart';
import 'package:exercise_journal/src/screens/edit_a_workout.dart';
import 'package:exercise_journal/src/screens/start_workout_journaling.dart';
import 'package:exercise_journal/src/screens/store_view.dart';
import 'package:exercise_journal/src/styles/base.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/custom_alert_dialog.dart';
import 'package:exercise_journal/src/widgets/display_exercise_list.dart';
import 'package:exercise_journal/src/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';

class WorkoutView extends StatefulWidget {
  //**************************************************************************\\
  //***************************** Constructor ********************************\\
  //**************************************************************************\\
  const WorkoutView({super.key});

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  //***************************** local variables *****************************\\
  final PageController ctrl = PageController(viewportFraction: 0.8);

  //keep track of current page to avoid unnecessary renders
  int currentPage = 0;
  late FToast fToast;

  //**************************************************************************\\
  //***************************** Constructor ********************************\\
  //**************************************************************************\\
  @override
  void initState() {
    super.initState();
    // WorkoutPlanBloc planingBloc =
    //     Provider.of<WorkoutPlanBloc>(context, listen: false);
    // JournalingBloc journalBloc =
    //     Provider.of<JournalingBloc>(context, listen: false);
    // planingBloc.workoutSaved.listen((saved) {
    //   if (saved == true) {
    //     _showToast("Workout Saved");
    //   } else {
    //     _showToast("failed to save");
    //   }
    // });
    // planingBloc.workoutDeleted.listen((saved) {
    //   if (saved == true) {
    //     _showToast("Workout Deleted");
    //   } else {
    //     _showToast("failed to Deleted");
    //   }
    // });
    // journalBloc.workoutSaved.listen((saved) {
    //   if (saved == true) {
    //     _showToast("Workout Saved");
    //   } else {
    //     _showToast("failed to save");
    //   }
    // });
    // fToast = FToast();
    // fToast.init(context);

    ctrl.addListener(
      () {
        final int next = ctrl.page!.round();
        if (currentPage != next) {
          setState(() {
            currentPage = next;
          });
        }
      },
    );
  }

  //**************************************************************************\\
  //*************************** build Function *******************************\\
  //**************************************************************************\\
  @override
  Widget build(BuildContext context) {
    return platformApp(context);
  }

  //**************************************************************************\\
  //****************************** Functions *********************************\\
  //**************************************************************************\\
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
  //   // TODO: this still give me an error:
  //   // Looking up a deactivated widget's ancestor is unsafe.
  //   // To safely refer to a widget's ancestor in its dispose() method, save a reference to the ancestor by calling dependOnInheritedWidgetOfExactType() in the widget's didChangeDependencies() method.
  //   SchedulerBinding.instance.addPostFrameCallback((_) {
  //     fToast.showToast(
  //       child: toast,
  //       gravity: ToastGravity.CENTER,
  //       toastDuration: const Duration(seconds: 1),
  //     );
  //   });
  // }

  Widget platformApp(BuildContext context) {
    // var planingBloc = Provider.of<WorkoutPlanBloc>(context);
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    List<AWorkout> allWorkouts = Provider.of<List<AWorkout>>(context);
    // This works because their is only one stream publishing List<AWorkout>> and its in the workout_planning_bloc
    // This function is called in the home controller and I'm searching up the widget tree until I find it. If data in the backend changes it will update the app
    // var workoutPlanning = Provider.of<WorkoutPlanBloc>(context);

    return StreamBuilder<int>(
      stream: authBloc.workoutLimiter,
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == null) {
          return const LoadingIndicator();
        }

        final int workoutLimit = snapshot.hasData ? snapshot.data! : 0;

        if (Platform.isIOS) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              border: null,
              middle: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pushNamed(StoreView.id),
                label: Text(
                  'Store',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColours.buttonText,
                  ),
                ),
                icon: Icon(
                  CupertinoIcons.shopping_cart,
                  size: 22.0,
                  color: AppColours.buttonText,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColours.primaryButton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: ElevatedButton.icon(
                onPressed: () =>
                    onAddPress(context, workoutLimit, allWorkouts.length),
                label: Text(
                  'Add',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColours.buttonText,
                  ),
                ),
                icon: Icon(
                  CupertinoIcons.add_circled,
                  size: 22.0,
                  color: AppColours.buttonText,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColours.primaryButton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              backgroundColor: AppColours.appBar,
            ),
            child: SafeArea(
              child: pageBody(allWorkouts, authBloc.userID.toString()),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: Container(),
              actions: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ElevatedButton.icon(
                //     onPressed: () {
                //       Navigator.of(context).pushNamed(StoreView.id);
                //     },
                //     label: Text(
                //       'Store',
                //       style: TextStyles.buttonText,
                //     ),
                //     icon: Icon(
                //       Icons.shopping_cart,
                //       color: AppColours.buttonText,
                //     ),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: AppColours.primaryButton,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10.0),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      onAddPress(context, workoutLimit, allWorkouts.length);
                    },
                    label: Text(
                      'Add',
                      style: TextStyles.buttonText,
                    ),
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: AppColours.buttonText,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColours.primaryButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                )
              ],
              backgroundColor: AppColours.appBar,
            ),
            body: pageBody(
              allWorkouts,
              authBloc.userID.toString(),
            ),
          );
        }
      },
    );
  }

  Widget pageBody(List<AWorkout> allWorkouts, String userId) {
    if (allWorkouts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please press the 'add' button, on the top right, to add your first workout",
              style: TextStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 35.0,
            ),
          ],
        ),
      );
    } else {
      return PageView.builder(
        controller: ctrl,
        itemCount: allWorkouts.length,
        itemBuilder: (BuildContext context, int currentIdx) {
          var aWorkout = allWorkouts[currentIdx];
          bool active = currentIdx == currentPage;
          return _buildPage(aWorkout, active);
        },
      );
    }
  }

  Widget _buildPage(AWorkout aWorkout, bool active) {
    //animated properties, active page to look different from other pages
    final double blur = active ? 20 : 0;
    final double offset = active ? 10 : 0;
    final double top = active ? 10 : 100;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 20, right: 20),
      decoration: BoxDecoration(
        color: AppColours.forground,
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColours.shadow,
            blurRadius: blur,
            offset: Offset(offset, offset),
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: AutoSizeText(
                      aWorkout.workoutName,
                      style: TextStyles.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          FontAwesomeIcons.pencil,
                          color: AppColours.edit,
                        ),
                      ],
                    ),
                    onTap: () => Navigator.of(context)
                        .pushNamed('${EditAWorkout.id}/${aWorkout.workoutID}'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(
              color: AppColours.shadow,
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: WeekdaySelector(
                        selectedFillColor: AppColours.primaryButton,
                        disabledColor: AppColours.disabled,
                        color: AppColours.textBody,
                        fillColor: AppColours.forground,
                        selectedElevation: 8,
                        elevation: 2,
                        onChanged: (day) {},
                        disabledElevation: 0,
                        values: aWorkout.activeDays,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    // UniqueKey() needed to re-render all widgets at the same time
                    // i.e. every time we get new data the UniqueKey() changes triggering re-build
                    // since keys don't match
                    ViewExercises(
                      workoutList: aWorkout,
                      key: UniqueKey(),
                    ),
                    const SizedBox(
                      height: 50.0,
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(6.0),
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      //Must load workout into memory for both planning and journaling blocks
                      Provider.of<JournalingBloc>(context, listen: false)
                          .setUpWorkoutJournaling(aWorkout);
                      Provider.of<WorkoutPlanBloc>(context, listen: false)
                          .loadWorkout(aWorkout);
                      Navigator.of(context).pushNamed(StartWorkoutJournal.id);
                    },
                    label: Text(
                      'Start',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColours.buttonText,
                      ),
                    ),
                    icon: Icon(
                      FontAwesomeIcons.circleChevronRight,
                      color: AppColours.buttonText,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColours.primaryButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //**************************************************************************\\
  //************************* Supporting Functions ****************************\\
  //**************************************************************************\\
  //show dialog function
  Widget showAlertDialog(BuildContext context, int workoutLimit) {
    return CustomAlertDialog(
      title: "Limit",
      description:
          'We have limited workouts to $workoutLimit to reduce our infrastructure costs ',
      primaryButtonText: 'Continue',
      primaryButton: () {
        Navigator.of(context).pop(false);
      },
    );
  }

  void onAddPress(BuildContext context, int workoutLimit, int totalWorkouts) {
    if (totalWorkouts >= workoutLimit) {
      (Platform.isIOS)
          ? showCupertinoDialog(
              context: context,
              builder: (BuildContext context) =>
                  showAlertDialog(context, workoutLimit),
            )
          : showDialog(
              context: context,
              builder: (BuildContext context) =>
                  showAlertDialog(context, workoutLimit),
            );
    } else {
      Navigator.of(context).pushNamed(EditAWorkout.id);
    }
  }
}
