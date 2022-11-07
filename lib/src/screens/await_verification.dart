import 'dart:async';
import 'dart:io';

import 'package:exercise_journal/src/app.dart';
import 'package:exercise_journal/src/blocs/auth_bloc.dart';
import 'package:exercise_journal/src/screens/home_view.dart';
import 'package:exercise_journal/src/screens/on_boarding.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AwaitingVerification extends StatefulWidget {
  static const String id = 'verification_screen';
  final String email;

  const AwaitingVerification({super.key, required this.email});

  @override
  State<AwaitingVerification> createState() => _AwaitingVerificationState();
}

class _AwaitingVerificationState extends State<AwaitingVerification> {
  late StreamSubscription _verificationSubscription;

  late Timer _timer;
  int _countDownTimer = 10;

  void startTimer() {
    const oneMin = Duration(seconds: 60);
    _timer = Timer.periodic(
      oneMin,
      (Timer timer) {
        if (_countDownTimer == 0) {
          setState(() {
            timer.cancel();
          });
        } else if (_countDownTimer != 10) {
          setState(() {
            _countDownTimer--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    final authBloc = Provider.of<AuthBloc>(context, listen: false);

    //Listen for email verification
    _verificationSubscription = authBloc.emailVerified.listen((verified) {
      if (verified) Navigator.pushReplacementNamed(context, Home.id);
    });
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _verificationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              border: null,
              trailing: GestureDetector(
                child: Icon(
                  Icons.logout,
                  color: AppColours.primaryButton,
                ),
                onTap: () {
                  authBloc.signOut();
                  Navigator.pushReplacementNamed(context, OnBoarding.id);
                },
              ),
              backgroundColor: AppColours.appBar,
            ),
            child: pageBody(context),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.rightFromBracket),
                  color: AppColours.primaryButton,
                  onPressed: () {
                    authBloc.signOut();
                    Navigator.pushReplacementNamed(context, OnBoarding.id);
                  },
                )
              ],
              backgroundColor: AppColours.appBar,
            ),
            body: pageBody(context),
          );
  }

  Widget pageBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: LoadingIndicator(
            text: "We've sent a message to ${widget.email}."
                '\n Please open to verify your email address'
                '\n You might need to check spam folder.',
          ),
        ),
        Text(
          "Re-send verification email in $_countDownTimer ${_countDownTimer == 1 ? 'Minute' : 'Minutes'}",
          style: TextStyles.suggestion,
        ),
        Expanded(
          child: reloadButton(),
        ),
      ],
    );
  }

  Widget reloadButton() {
    if (Platform.isIOS) {
      return CupertinoButton(
        child: Icon(
          FontAwesomeIcons.arrowsRotate,
          color: _countDownTimer == 0
              ? AppColours.primaryButton
              : AppColours.disabled,
        ),
        onPressed: () {
          if (_countDownTimer == 0) {
            _countDownTimer = 10;
            startTimer();
            authBloc.verifyEmail();
          }
        },
      );
    } else {
      return IconButton(
        icon: Icon(
          FontAwesomeIcons.arrowsRotate,
          color: _countDownTimer == 0
              ? AppColours.primaryButton
              : AppColours.disabled,
        ),
        onPressed: () {
          if (_countDownTimer == 0) {
            _countDownTimer = 10;
            startTimer();
            authBloc.verifyEmail();
          }
        },
      );
    }
  }
}
