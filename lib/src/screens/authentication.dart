import 'dart:async';
import 'dart:io';

// import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/app.dart';
import 'package:exercise_journal/src/blocs/auth_bloc.dart';
import 'package:exercise_journal/src/screens/await_verification.dart';
import 'package:exercise_journal/src/screens/home_view.dart';
import 'package:exercise_journal/src/styles/base.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/widgets/app_textfield.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:exercise_journal/src/widgets/policy_buttons.dart';
import 'package:exercise_journal/src/widgets/text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:auth_buttons/auth_buttons.dart';
import 'package:provider/provider.dart';

enum AuthFormType { signIn, signUp, reset }

class Authentication extends StatefulWidget {
  final AuthFormType authFormType;
  static const String signUpID = 'registration_screen';
  static const String signInID = 'signIn_screen';

  const Authentication({super.key, required this.authFormType});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  late AuthFormType authFormType = widget.authFormType;
  UnfocusDisposition disposition = UnfocusDisposition.scope;

  _AuthenticationState();

  // StreamSubscription _userSubscription;
  late StreamSubscription _errorMessageSubscription;
  String _warning = '';

  @override
  void initState() {
    final authBloc = Provider.of<AuthBloc>(context, listen: false);
    authBloc.user.listen((user) {
      if (user.email != '') {
        if (user.verified == true) {
          Navigator.pushReplacementNamed(context, Home.id);
        } else {
          Navigator.pushReplacementNamed(
            context,
            "${AwaitingVerification.id}/${user.email}",
          );
        }
      }
    });
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
//    _userSubscription.cancel();
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
        backgroundColor: AppColours.background,
        child: pageBody(context, authBloc),
      );
    }
    return Scaffold(
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
            Flexible(
              child: Container(
                width: 130,
                height: 160,
                padding: const EdgeInsets.all(10),
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
            ),
            const SizedBox(height: 20.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: _buildTextFieldInputs() + buildButtons(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTextFieldInputs() {
    final List<Widget> textFields = [];

    if (authFormType == AuthFormType.reset) {
      textFields.add(
        StreamBuilder<String>(
          stream: authBloc.email,
          builder: (context, snapshot) {
            return AppTextField(
              isIOS: Platform.isIOS,
              hintText: 'Enter your Email',
              textInputType: TextInputType.emailAddress,
              errorText:
                  snapshot.error == null ? '' : snapshot.error.toString(),
              onChanged: authBloc.changeEmail,
            );
          },
        ),
      );
      textFields.add(const SizedBox(height: 20.0));
      return textFields;
    }

    if (authFormType == AuthFormType.signUp) {
      textFields.add(
        StreamBuilder<String>(
          stream: authBloc.name,
          builder: (context, snapshot) {
            return AppTextField(
              isIOS: Platform.isIOS,
              hintText: 'Enter your Name',
              errorText:
                  snapshot.error == null ? '' : snapshot.error.toString(),
              onChanged: authBloc.changedName,
            );
          },
        ),
      );
      textFields.add(const SizedBox(height: 8.0));
    }

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

    if (authFormType == AuthFormType.signUp) {
      textFields.add(
        StreamBuilder<String?>(
          stream: authBloc.confirmEmail,
          builder: (context, snapshot) {
            return AppTextField(
              isIOS: Platform.isIOS,
              hintText: 'Confirm your Email',
              textInputType: TextInputType.emailAddress,
              errorText:
                  snapshot.error == null ? '' : snapshot.error.toString(),
              onChanged: authBloc.changeConfirmEmail,
            );
          },
        ),
      );

      textFields.add(const SizedBox(height: 8.0));
    }

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

    if (authFormType == AuthFormType.signUp) {
      textFields.add(
        StreamBuilder<String?>(
          stream: authBloc.confirmPassword,
          builder: (context, snapshot) {
            return AppTextField(
              isIOS: Platform.isIOS,
              hintText: 'Confirm your Password',
              obscureText: true,
              errorText:
                  snapshot.error == null ? '' : snapshot.error.toString(),
              onChanged: authBloc.changeConfirmPassword,
            );
          },
        ),
      );
      textFields.add(const SizedBox(height: 8.0));
    }

    return textFields;
  }

  // switchFormState(String state) {
  //   setState(() {
  //     if (state == 'Sign Up') {
  //       authFormType = AuthFormType.signUp;
  //     } else if (state == 'Home') {
  //       Navigator.of(context).pop();
  //     } else {
  //       authFormType = AuthFormType.signIn;
  //     }
  //   });
  // }

  List<Widget> buildButtons() {
    String switchButtonText;
    String newFormState;
    String submitButtonText;
    bool showForgotPassword = false;
    //bool _showSocial = true;
    bool showTandC = true;

    if (authFormType == AuthFormType.signIn) {
      switchButtonText = 'Create New Account';
      newFormState = 'Sign Up';
      submitButtonText = 'Sign In';
      showForgotPassword = true;
      showTandC = false;
    } else if (authFormType == AuthFormType.reset) {
      switchButtonText = 'Return to Sign In';
      newFormState = 'Sign In';
      submitButtonText = 'Submit';
      //_showSocial = false;
      showTandC = false;
    } else {
      switchButtonText = 'Have an Account? Sign In';
      newFormState = 'Sign In';
      submitButtonText = 'Sign Up';
    }

    return [
      displayButton(submitButtonText),
      forgotPasswordButton(visible: showForgotPassword),
      PlainTextButton(
        buttonText: switchButtonText,
        onPressed: () => setState(() {
          primaryFocus!.unfocus(disposition: disposition);
          if (newFormState == 'Sign Up') {
            authFormType = AuthFormType.signUp;
          } else if (newFormState == 'Home') {
            Navigator.of(context).pop();
          } else {
            authFormType = AuthFormType.signIn;
          }
        }),
      ),
      //buildSocialicons(_showSocial),
      PolicyButtons(showTandC: showTandC),
    ];
  }

  Widget displayButton(String buttonText) {
    if (authFormType == AuthFormType.signIn) {
      return StreamBuilder<bool>(
        stream: authBloc.isEmailSignInValid,
        builder: (context, snapshot) {
          return AppButton(
            buttonText: buttonText,
            buttonType: snapshot.data == true
                ? ButtonType.primary
                : ButtonType.disabled,
            onPressed: submit,
          );
        },
      );
    } else if (authFormType == AuthFormType.signUp) {
      return StreamBuilder<bool>(
        stream: authBloc.isEmailSignupValid,
        builder: (context, snapshot) {
          return AppButton(
            buttonText: buttonText,
            buttonType: snapshot.data == true
                ? ButtonType.primary
                : ButtonType.disabled,
            onPressed: submit,
          );
        },
      );
    }
    return StreamBuilder<String>(
      stream: authBloc.email,
      builder: (context, snapshot) {
        return AppButton(
          buttonText: buttonText,
          buttonType:
              snapshot.hasError ? ButtonType.disabled : ButtonType.primary,
          onPressed: submit,
        );
      },
    );
  }

  Future<void> submit() async {
    primaryFocus!.unfocus(disposition: disposition);
    switch (authFormType) {
      case AuthFormType.signIn:
        await authBloc.signInEmail();
        break;
      case AuthFormType.signUp:
        authBloc.signUpEmail();
        break;
      case AuthFormType.reset:
        authBloc.sendPasswordRestartEmail();
        setState(() {
          authFormType = AuthFormType.signIn;
        });
        break;
    }
  }

  Widget forgotPasswordButton({required bool visible}) {
    return Visibility(
      visible: visible,
      child: PlainTextButton(
        buttonText: 'Forgot Password?',
        onPressed: () => setState(() {
          primaryFocus!.unfocus(disposition: disposition);
          authFormType = AuthFormType.reset;
        }),
      ),
    );
  }

// Widget buildSocialicons(bool visible) {
//   return Visibility(
//     visible: visible,
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: <Widget>[
//         Row(
//           children: <Widget>[
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                   left: 10.0,
//                   right: 20.0,
//                 ),
//                 child: Divider(
//                   color: Colors.blueGrey,
//                 ),
//               ),
//             ),
//             Text(
//               'or',
//               style: TextStyles.suggestion,
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                   left: 10.0,
//                   right: 20.0,
//                 ),
//                 child: Divider(
//                   color: Colors.blueGrey,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: GoogleAuthButton(
//             darkMode: true,
//             onPressed: () {
//               authBloc.signinGoogle();
//             },
//           ),
//         )
//       ],
//     ),
//   );
// }
}
