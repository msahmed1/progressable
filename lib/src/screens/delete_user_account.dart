import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/app.dart';
import 'package:exercise_journal/src/blocs/auth_bloc.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/app_textfield.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DeleteAccount extends StatefulWidget {
  static const String id = 'delete_account_screen';

  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  String _warning = '';
  late StreamSubscription _errorMessageSubscription;
  static const String buttonText = 'Delete Account';

  @override
  void initState() {
    final authBloc = Provider.of<AuthBloc>(context, listen: false);
    _errorMessageSubscription = authBloc.errorMessage.listen((errorMessage) {
      if (errorMessage != '') {
        setState(() {
          _warning = errorMessage;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _errorMessageSubscription.cancel();
    super.dispose();
  }

  Widget showAlert() {
    if (_warning != '') {
      return Container(
        color: AppColours.warning,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
              child: GestureDetector(
                child: const Icon(Icons.close),
                onTap: () {
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
    final authBloc = Provider.of<AuthBloc>(context);

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: GestureDetector(
            child: Icon(
              CupertinoIcons.xmark,
              color: AppColours.primaryButton,
            ),
            onTap: () {
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 2);
            },
          ),
          middle: Text(
            'Delete Account',
            style: TextStyles.title,
          ),
          backgroundColor: AppColours.appBar,
        ),
        child: pageBody(context, authBloc),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.xmark,
            color: AppColours.primaryButton,
          ),
          onPressed: () {
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);
          },
        ),
        title: Text(
          'Delete Account',
          style: TextStyles.title,
        ),
        backgroundColor: AppColours.appBar,
      ),
      body: pageBody(context, authBloc),
      backgroundColor: AppColours.background,
    );
  }

  Widget pageBody(BuildContext context, AuthBloc authBloc) {
    final height = MediaQuery.of(context).size.height;
    // final _width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: height * 0.025),
            showAlert(),
            SizedBox(height: height * 0.025),
            // Flexible(
            //   child: Container(
            //     width: 130,
            //     height: 160,
            //     padding: const EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //       color: AppColours.background,
            //       borderRadius: const BorderRadius.all(
            //         Radius.circular(15),
            //       ),
            //       boxShadow: BaseStyles.imageShadow,
            //     ),
            //     child: const Image(
            //       image: AssetImage('assets/images/logo.png'),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AutoSizeText(
                'To delete account submit the correct log in details'
                '\n\n Incorrect credentials will log you out without deleting account',
                style: TextStyles.body,
                maxLines: 5,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: _buildTextFieldInputs(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTextFieldInputs() {
    final List<Widget> textFields = [];

    textFields.add(
      StreamBuilder<String>(
        stream: authBloc.email,
        builder: (context, snapshot) {
          return AppTextField(
            isIOS: Platform.isIOS,
            hintText: 'Enter your Email',
            textInputType: TextInputType.emailAddress,
            errorText: snapshot.error == null ? '' : snapshot.error.toString(),
            onChanged: authBloc.changeEmail,
          );
        },
      ),
    );

    textFields.add(const SizedBox(height: 8.0));

    textFields.add(
      StreamBuilder<String>(
        stream: authBloc.password,
        builder: (context, snapshot) {
          return AppTextField(
            isIOS: Platform.isIOS,
            hintText: 'Enter your Password',
            obscureText: true,
            errorText: snapshot.error == null ? '' : snapshot.error.toString(),
            onChanged: authBloc.changePassword,
          );
        },
      ),
    );

    textFields.add(const SizedBox(height: 8.0));

    textFields.add(deleteAccountButton());

    textFields.add(const SizedBox(height: 8.0));

    return textFields;
  }

  Widget deleteAccountButton() {
    return StreamBuilder<bool>(
      stream: authBloc.isEmailSignInValid,
      builder: (context, snapshot) {
        return AppButton(
          buttonText: buttonText,
          buttonType:
              snapshot.data == true ? ButtonType.primary : ButtonType.disabled,
          onPressed: submit,
        );
      },
    );
  }

  Future<void> submit() async {
    await authBloc.deleteUserAccount();
  }
}
