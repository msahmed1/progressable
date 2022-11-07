import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/app.dart';
import 'package:exercise_journal/src/screens/authentication.dart';
import 'package:exercise_journal/src/styles/base.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:exercise_journal/src/widgets/text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  static const String id = 'onboarding_screen';

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late StreamSubscription _errorMessageSubscription;
  late String _warning;

  @override
  void initState() {
    _errorMessageSubscription = authBloc.errorMessage.listen((errorMessage) {
      if (errorMessage != '') {
        setState(() {
          _warning = errorMessage;
        });
      }
    });
    super.initState();
  }

  Widget showAlert() {
    if (_warning != '') {
      return Container(
        color: AppColours.warning,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = '';
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoPageScaffold(
            backgroundColor: AppColours.background,
            child: SingleChildScrollView(
              child: pageBody(context),
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: pageBody(context),
            ),
            backgroundColor: AppColours.background,
          );
  }

  @override
  void dispose() {
    _errorMessageSubscription.cancel();
    super.dispose();
  }

  Widget pageBody(BuildContext context) {
    // final _width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: height * 0.70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: height * 0.02,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColours.background,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          boxShadow: BaseStyles.imageShadow,
                        ),
                        child: const Image(
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Progressable',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          color: AppColours.title,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.10,
                ),
                Text(
                  'Welcome',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 44,
                    color: AppColours.textBody,
                  ),
                ),
                SizedBox(
                  height: height * 0.10,
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AutoSizeText(
                    "Let's start planning your next workout",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 44,
                      color: AppColours.textBody,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              height: height * 0.26,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
                color: AppColours.midground,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SizedBox(
                  //   height: _height * 0.10,
                  // ),
                  AppButton(
                    buttonText: 'Sign up',
                    buttonType: ButtonType.primary,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        Authentication.signUpID,
                      );
                    },
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  PlainTextButton(
                    buttonText: 'Sign In',
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        Authentication.signInID,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
