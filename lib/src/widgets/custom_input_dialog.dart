import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:flutter/material.dart';
// import 'package:exercise_journal/src/styles/text.dart';

class CustomInputDialog extends StatelessWidget {
  final String title;
  final Widget formBody;

  final Function onSubmit;

  static const double padding = 20.0;

  const CustomInputDialog({
    super.key,
    required this.title,
    required this.formBody,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColours.background,
        borderRadius: BorderRadius.circular(20.0),
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
                const SizedBox(height: 8.0),
                AutoSizeText(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyles.title,
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
          formBody,
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              cancelButton(context),
              submitButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget cancelButton(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
            ),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
            ),
          ),
          alignment: Alignment.center,
          height: 50,
          child: Text(
            "Cancel",
            style: TextStyles.textButton,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColours.shadow,
          backgroundColor: AppColours.primaryButton,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
        ),
        //onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FoodForm(food: food, foodIndex: index),),),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          alignment: Alignment.center,
          height: 50,
          child: Text(
            "submit",
            style: TextStyles.buttonText,
          ),
        ),
        onPressed: () {
          onSubmit();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
