import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/blocs/journaling_bloc.dart';
import 'package:exercise_journal/src/models/workout_planning_template/strength_training.dart';
import 'package:exercise_journal/src/styles/base.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/exercise_type_representation.dart';
import 'package:exercise_journal/src/widgets/journal_table.dart';
import 'package:exercise_journal/src/widgets/note_card.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplayWorkout extends StatefulWidget {
  //**************************************************************************\\
  //***************************** Constructor ********************************\\
  //**************************************************************************\\
  const DisplayWorkout({super.key});

  @override
  State<DisplayWorkout> createState() => _DisplayWorkoutState();
}

class _DisplayWorkoutState extends State<DisplayWorkout> {
  //***************************** local variables *****************************\\
  List<bool> isExpanded = [];

  //**************************************************************************\\
  //*************************** build Function *******************************\\
  //**************************************************************************\\
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: Provider.of<JournalingBloc>(context).orderedTargets,
      builder: (context, snapshot) {
        final orderedTargets = snapshot.data;

        if (orderedTargets == null || orderedTargets.isEmpty) {
          return Padding(
            padding: BaseStyles.listPadding,
            child: Text(
              'Your workout is empty, edit this workout to add exercises',
              textAlign: TextAlign.center,
              style: TextStyles.body,
            ),
          );
        }

        return StreamBuilder<List<dynamic>>(
          stream: Provider.of<JournalingBloc>(context).orderedActual,
          builder: (context, snapshot) {
            // Make a list of expansion tiles of all exercises
            return ListView(
              children: [
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  itemCount: orderedTargets.length,
                  itemBuilder: (BuildContext context, int index) {
                    final exerciseFromSequence = orderedTargets[index];
                    if (isExpanded.isEmpty) {
                      isExpanded =
                          List<bool>.filled(orderedTargets.length, false);
                    }

                    if (snapshot.hasData) {
                      return journalingExpansionTile(
                        target: exerciseFromSequence,
                        actual: snapshot.data![index],
                        index: index,
                      );
                    }
                    return Container();
                  },
                ),
                const NoteCard(),
              ],
            );
          },
        );
      },
    );
  }

  //**************************************************************************\\
  //****************************** Functions *********************************\\
  //**************************************************************************\\
  Widget journalingExpansionTile({var target, var actual, required int index}) {
    return Padding(
      padding: BaseStyles.listPadding,
      child: ExpansionTileCard(
        expandedTextColor: AppColours.title,
        expandedColor: AppColours.midground,
        baseColor: AppColours.forground,
        initialElevation: 2.0,
        onExpansionChanged: (expanded) {
          setState(() {
            isExpanded[index] = expanded;
          });
        },
        title: AutoSizeText(
          target is StrengthTraining
              ? target.strengthExerciseName
              : target.aerobicExerciseName as String,
          maxLines: 1,
          style: TextStyles.body,
          textAlign: TextAlign.start,
        ),
        leading: Text(
          '#${target.sequence + 1}',
          style: TextStyles.suggestion,
          textAlign: TextAlign.center,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WorkoutTypeColorRepresentation(
              exercise: target,
              exerciseType: target.exerciseType as String,
            ),
            const SizedBox(width: 10.0),
            if (isExpanded[index])
              Icon(
                Icons.arrow_drop_up_outlined,
                color: AppColours.suggestion,
              )
            else
              Icon(
                Icons.arrow_drop_down_outlined,
                color: AppColours.suggestion,
              )
          ],
        ),
        children: [
          // when tile is expanded display the contents of the exercise
          JournalTable(target: target, actual: actual),
        ],
      ),
    );
  }
}
