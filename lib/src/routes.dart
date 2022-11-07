import 'package:exercise_journal/src/screens/authentication.dart';
import 'package:exercise_journal/src/screens/await_verification.dart';
import 'package:exercise_journal/src/screens/delete_user_account.dart';
import 'package:exercise_journal/src/screens/edit_a_exercise.dart';
import 'package:exercise_journal/src/screens/edit_a_workout.dart';
import 'package:exercise_journal/src/screens/edit_note_page.dart';
import 'package:exercise_journal/src/screens/health_profile.dart';
import 'package:exercise_journal/src/screens/home_view.dart';
import 'package:exercise_journal/src/screens/journal_entry.dart';
import 'package:exercise_journal/src/screens/licence_page.dart';
import 'package:exercise_journal/src/screens/on_boarding.dart';
import 'package:exercise_journal/src/screens/privacy_center.dart';
import 'package:exercise_journal/src/screens/settings.dart';
import 'package:exercise_journal/src/screens/start_workout_journaling.dart';
import 'package:exercise_journal/src/screens/store_view.dart';
import 'package:exercise_journal/src/screens/substitution_page.dart';
import 'package:exercise_journal/src/screens/summary_screen.dart';
import 'package:exercise_journal/src/widgets/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

CupertinoPageRoute customCupertinoRoutes(RouteSettings settings) {
  switch (settings.name) {
    case OnBoarding.id:
      return CupertinoPageRoute(builder: (context) => const OnBoarding());
    case Home.id:
      return CupertinoPageRoute(builder: (context) => const Home());
    case HealthProfile.id:
      return CupertinoPageRoute(builder: (context) => const HealthProfile());
    case Settings.id:
      return CupertinoPageRoute(builder: (context) => const Settings());
    case PrivacyCenter.id:
      return CupertinoPageRoute(builder: (context) => const PrivacyCenter());
    case Authentication.signInID:
      return CupertinoPageRoute(
        builder: (context) =>
            const Authentication(authFormType: AuthFormType.signIn),
      );
    case Authentication.signUpID:
      return CupertinoPageRoute(
        builder: (context) =>
            const Authentication(authFormType: AuthFormType.signUp),
      );
    case EditAWorkout.id:
      return CupertinoPageRoute(builder: (context) => const EditAWorkout());
    case EditExercise.addNew:
      return CupertinoPageRoute(
        builder: (context) => const EditExercise(
          exerciseType: ExerciseType.addNew,
        ),
      );
    case StartWorkoutJournal.id:
      return CupertinoPageRoute(
        builder: (context) => const StartWorkoutJournal(),
      );
    case JournalEntry.id:
      return CupertinoPageRoute(builder: (context) => const JournalEntry());
    case LicensePageCustom.id:
      return CupertinoPageRoute(
        builder: (context) => const LicensePageCustom(),
      );
    case StoreView.id:
      return CupertinoPageRoute(builder: (context) => const StoreView());
    case DeleteAccount.id:
      return CupertinoPageRoute(builder: (context) => const DeleteAccount());
    default:
      final routArray = settings.name!.split('/');
      if (settings.name!.contains(AwaitingVerification.id)) {
        return CupertinoPageRoute(
          builder: (context) => AwaitingVerification(email: routArray[1]),
        );
      } else if (settings.name!.contains(EditAWorkout.id)) {
        return CupertinoPageRoute(
          builder: (context) => EditAWorkout(workoutID: routArray[1]),
        );
      } else if (settings.name!.contains(EditExercise.update)) {
        return CupertinoPageRoute(
          builder: (context) => EditExercise(
            exerciseType: ExerciseType.update,
            sequencePos: int.parse(routArray[1]),
            subSequencePos: int.parse(routArray[2]),
          ),
        );
      } else if (settings.name!.contains(EditExercise.addSubstitute)) {
        return CupertinoPageRoute(
          builder: (context) => EditExercise(
            exerciseType: ExerciseType.addSubstitute,
            sequencePos: int.parse(routArray[1]),
          ),
        );
      } else if (settings.name!.contains(SubstituteExercise.id)) {
        return CupertinoPageRoute(
          builder: (context) => const SubstituteExercise(),
        );
      } else if (settings.name!.contains(JournalEntry.id)) {
        return CupertinoPageRoute(
          builder: (context) => JournalEntry(
            sequence: int.parse(routArray[1]),
            exerciseType: routArray[2],
          ),
        );
      } else if (settings.name!.contains(EditNotesView.id)) {
        return CupertinoPageRoute(
          builder: (context) => EditNotesView(
            sequence: int.parse(routArray[1]),
          ),
        );
      } else if (settings.name!.contains(SummaryScreen.id)) {
        return CupertinoPageRoute(
          builder: (context) => SummaryScreen(
            time: int.parse(routArray[1]),
          ),
        );
      }
      return CupertinoPageRoute(builder: (context) => const HomeController());
  }
}

MaterialPageRoute customMaterialRoutes(RouteSettings settings) {
  switch (settings.name) {
    case OnBoarding.id:
      return MaterialPageRoute(builder: (context) => const OnBoarding());
    case Home.id:
      return MaterialPageRoute(builder: (context) => const Home());
    case HealthProfile.id:
      return MaterialPageRoute(builder: (context) => const HealthProfile());
    case Settings.id:
      return MaterialPageRoute(builder: (context) => const Settings());
    case PrivacyCenter.id:
      return MaterialPageRoute(builder: (context) => const PrivacyCenter());
    case Authentication.signInID:
      return MaterialPageRoute(
        builder: (context) =>
            const Authentication(authFormType: AuthFormType.signIn),
      );
    case Authentication.signUpID:
      return MaterialPageRoute(
        builder: (context) =>
            const Authentication(authFormType: AuthFormType.signUp),
      );
    case EditAWorkout.id:
      return MaterialPageRoute(builder: (context) => const EditAWorkout());
    case EditExercise.addNew:
      return MaterialPageRoute(
        builder: (context) => const EditExercise(
          exerciseType: ExerciseType.addNew,
        ),
      );
    case StartWorkoutJournal.id:
      return MaterialPageRoute(
        builder: (context) => const StartWorkoutJournal(),
      );
    case JournalEntry.id:
      return MaterialPageRoute(builder: (context) => const JournalEntry());
    case LicensePageCustom.id:
      return MaterialPageRoute(builder: (context) => const LicensePageCustom());
    case StoreView.id:
      return MaterialPageRoute(builder: (context) => const StoreView());
    case DeleteAccount.id:
      return MaterialPageRoute(builder: (context) => const DeleteAccount());
    default:
      final routArray = settings.name!.split('/');
      if (settings.name!.contains(AwaitingVerification.id)) {
        return MaterialPageRoute(
          builder: (context) => AwaitingVerification(email: routArray[1]),
        );
      } else if (settings.name!.contains(EditAWorkout.id)) {
        return MaterialPageRoute(
          builder: (context) => EditAWorkout(workoutID: routArray[1]),
        );
      } else if (settings.name!.contains(EditExercise.update)) {
        return MaterialPageRoute(
          builder: (context) => EditExercise(
            exerciseType: ExerciseType.update,
            sequencePos: int.parse(routArray[1]),
            subSequencePos: int.parse(routArray[2]),
          ),
        );
      } else if (settings.name!.contains(EditExercise.addSubstitute)) {
        return MaterialPageRoute(
          builder: (context) => EditExercise(
            exerciseType: ExerciseType.addSubstitute,
            sequencePos: int.parse(routArray[1]),
          ),
        );
      } else if (settings.name!.contains(SubstituteExercise.id)) {
        return MaterialPageRoute(
          builder: (context) => const SubstituteExercise(),
        );
      } else if (settings.name!.contains(JournalEntry.id)) {
        return MaterialPageRoute(
          builder: (context) => JournalEntry(
            sequence: int.parse(routArray[1]),
            exerciseType: routArray[2],
          ),
        );
      } else if (settings.name!.contains(EditNotesView.id)) {
        return MaterialPageRoute(
          builder: (context) => EditNotesView(
            sequence: int.parse(routArray[1]),
          ),
        );
      } else if (settings.name!.contains(SummaryScreen.id)) {
        return MaterialPageRoute(
          builder: (context) => SummaryScreen(
            time: int.parse(routArray[1]),
          ),
        );
      }
      return MaterialPageRoute(builder: (context) => const HomeController());
  }
}
