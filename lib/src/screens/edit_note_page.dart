import 'dart:io';

import 'package:exercise_journal/src/blocs/journaling_bloc.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/styles/textfields.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditNotesView extends StatefulWidget {
  static const String id = 'edit_notes_view';
  final int sequence;
  static const int workoutLevelNote = -1;

  const EditNotesView({
    this.sequence = workoutLevelNote,
    super.key,
  });

  @override
  State<EditNotesView> createState() => _EditNotesViewState();
}

class _EditNotesViewState extends State<EditNotesView> {
  late FocusNode _focusNode;
  TextEditingController _notesController = TextEditingController();

  // void openKeyboard() {
  //   FocusScope.of(context).requestFocus(_focusNode);
  // }

  @override
  void initState() {
    _focusNode = FocusNode();
    _notesController = TextEditingController();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _focusNode.requestFocus();
    // });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    JournalingBloc journalBloc = Provider.of<JournalingBloc>(context);
    journalBloc.loadNote(widget.sequence);

    return StreamBuilder<String>(
      stream: widget.sequence == -1
          ? journalBloc.workoutNote
          : journalBloc.exerciseNote,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != '' && _notesController.text.isEmpty) {
            _notesController.text = snapshot.data!;
          }
        }

        return Hero(
          tag: 'workout-notes',
          transitionOnUserGestures: true,
          child: Platform.isIOS
              ? CupertinoPageScaffold(
                  child: pageBody(context),
                )
              : Scaffold(
                  body: pageBody(context),
                ),
        );
      },
    );
  }

  Widget pageBody(BuildContext context) {
    JournalingBloc journalBloc = Provider.of<JournalingBloc>(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildHeading(context),
            Expanded(
              child: ListView(
                children: <Widget>[buildTextInput(isIOS: Platform.isIOS)],
              ),
            ),
            buildSubmitButton(context, journalBloc),
          ],
        ),
      ),
    );
  }

  Widget buildHeading(BuildContext context) {
    // returning material, since during the transition of Hero() we get errors
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Text(
              widget.sequence == -1 ? 'Workout note' : 'Exercise note',
              style: TextStyles.title,
            ),
          ),
          TextButton(
            child: Icon(
              FontAwesomeIcons.xmark,
              color: AppColours.primaryButton,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Widget buildTextInput({required bool isIOS}) {
    return isIOS
        ? CupertinoTextField(
            padding: const EdgeInsets.all(20.0),
            maxLines: null,
            placeholderStyle: TextFieldsStyles.placeHolder,
            controller: _notesController,
            autofocus: true,
            focusNode: _focusNode,
            style: TextFieldsStyles.text,
            cursorColor: AppColours.primaryButton,
            decoration: const BoxDecoration(),
          )
        : Material(
            color: AppColours.background,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                maxLines: null,
                controller: _notesController,
                autofocus: true,
                focusNode: _focusNode,
                style: TextFieldsStyles.text,
                cursorColor: AppColours.primaryButton,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          );
  }

  Widget buildSubmitButton(BuildContext context, JournalingBloc journalBloc) {
    return AppButton(
      buttonText: 'Save',
      buttonType: ButtonType.primary,
      onPressed: () {
        if (widget.sequence == -1) {
          journalBloc.changeWorkoutNote(_notesController.text);
        } else {
          journalBloc.saveExerciseNote(widget.sequence, _notesController.text);
        }
        Navigator.of(context).pop();
      },
    );
  }
}
