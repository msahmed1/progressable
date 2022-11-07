import 'dart:io';

import 'package:exercise_journal/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  final String text;

  const LoadingIndicator({this.text = '', super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody(const CupertinoActivityIndicator()),
          )
        : Scaffold(
            body: pageBody(const CircularProgressIndicator()),
          );
  }

  Widget pageBody(Widget activityIndicator) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.text,
            style: TextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 35.0,
          ),
          activityIndicator,
        ],
      ),
    );
  }
}
