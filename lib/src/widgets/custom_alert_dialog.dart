import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String description;
  final String primaryButtonText;
  final String secondaryButtonText;

  //Not sure if the ? will work but putting it in for now
  final Function()? primaryButton;
  final Function()? secondaryButton;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.description,
    required this.primaryButtonText,
    required this.primaryButton,
    this.secondaryButtonText = '',
    this.secondaryButton,
  });

  static const double padding = 20.0;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyles.title,
        ),
        content: Text(description),
        actions: <Widget>[
          if (secondaryButton != null && secondaryButtonText != '')
            CupertinoDialogAction(
              onPressed: secondaryButton,
              child: Text(secondaryButtonText),
            ),
          CupertinoDialogAction(
            onPressed: primaryButton,
            child: Text(primaryButtonText),
          ),
        ],
      );
    } else {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(padding),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColours.background,
            borderRadius: BorderRadius.circular(padding),
            boxShadow: [
              BoxShadow(
                color: AppColours.shadow,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(
                  padding,
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 24.0),
                    AutoSizeText(
                      title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyles.title,
                    ),
                    const SizedBox(height: 24.0),
                    AutoSizeText(
                      description,
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      style: TextStyles.body,
                    ),
                    const SizedBox(height: 24.0),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  showSecondaryButton(context),
                  showPrimaryButton(context),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget showPrimaryButton(BuildContext context) {
    BorderRadius buttonBorder = const BorderRadius.only(
      topLeft: Radius.circular(padding),
      bottomRight: Radius.circular(padding),
    );

    if (secondaryButton == null && secondaryButtonText == '') {
      buttonBorder = const BorderRadius.only(
        bottomRight: Radius.circular(padding),
        bottomLeft: Radius.circular(padding),
      );
    }

    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColours.shadow,
          backgroundColor: AppColours.primaryButton,
          shape: RoundedRectangleBorder(
            borderRadius: buttonBorder,
          ),
        ),
        onPressed: primaryButton,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(padding),
              bottomLeft: Radius.circular(padding),
            ),
          ),
          alignment: Alignment.center,
          height: 50,
          width: double.infinity,
          child: AutoSizeText(
            primaryButtonText,
            maxLines: 1,
            style: TextStyles.buttonText,
          ),
        ),
      ),
    );
  }

  Widget showSecondaryButton(BuildContext context) {
    if (secondaryButton != null && secondaryButtonText != '') {
      return Expanded(
        child: TextButton(
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(padding),
                bottomLeft: Radius.circular(padding),
              ),
            ),
          ),
          onPressed: secondaryButton,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(padding),
                bottomLeft: Radius.circular(padding),
              ),
            ),
            alignment: Alignment.center,
            height: 50,
            width: double.infinity,
            child: AutoSizeText(
              secondaryButtonText,
              maxLines: 1,
              style: TextStyles.textButton,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox(height: 10.0);
    }
  }
}
