import 'dart:io';

import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PolicyDialog extends StatelessWidget {
  PolicyDialog({
    super.key,
    this.radius = 20.0,
    required this.mdFileName,
  }) : assert(
          mdFileName.contains('.md'),
          'The file must contain the .md extension',
        );

  final double radius;
  final String mdFileName;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: CupertinoPopupSurface(
          child: Column(
            children: [
              dialogBody(),
              CupertinoButton(
                child: const Text("CLOSE"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
    } else {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        child: Column(
          children: [
            dialogBody(),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColours.shadow,
                backgroundColor: AppColours.primaryButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                  ),
                ),
                padding: EdgeInsets.zero,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                  ),
                ),
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                child: Text(
                  "CLOSE",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColours.buttonText,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget dialogBody() {
    return Expanded(
      child: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 150)).then((value) {
          return rootBundle.loadString('assets/policies/$mdFileName');
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Markdown(
              data: snapshot.data.toString(),
            );
          }
          return LoadingIndicator(text: 'Retrieving $mdFileName documentation');
        },
      ),
    );
  }
}
