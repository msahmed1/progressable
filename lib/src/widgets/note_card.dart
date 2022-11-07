import 'package:exercise_journal/src/blocs/journaling_bloc.dart';
import 'package:exercise_journal/src/screens/edit_note_page.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    JournalingBloc journalBloc = Provider.of<JournalingBloc>(context);
    return
        // Hero(
        // tag: 'workout-notes',
        // transitionOnUserGestures: true,
        // child:
        Card(
      color: AppColours.primaryButton,
      child: InkWell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Workout Note',
                      style: TextStyles.buttonText,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: setNoteText(journalBloc),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).pushNamed('${EditNotesView.id}/${-1}');
        },
      ),
      // ),
    );
  }

  Widget setNoteText(JournalingBloc journalBloc) {
    return StreamBuilder<String>(
      stream: journalBloc.workoutNote,
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data == '') {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.add_circle_outline,
                  color: AppColours.textBody,
                  size: 20.0,
                ),
              ),
              Expanded(
                child: Text(
                  "Click To Add Notes",
                  style: TextStyles.suggestion
                      .copyWith(color: AppColours.textBody),
                ),
              ),
            ],
          );
        }
        return Row(
          children: [
            Expanded(
              child: Text(
                snapshot.data!,
                style:
                    TextStyles.suggestion.copyWith(color: AppColours.textBody),
                textAlign: TextAlign.left,
              ),
            )
          ],
        );
      },
    );
  }
}
