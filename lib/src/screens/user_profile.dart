import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/blocs/ad_mob_bloc.dart';
import 'package:exercise_journal/src/blocs/auth_bloc.dart';
import 'package:exercise_journal/src/models/user.dart';
import 'package:exercise_journal/src/screens/delete_user_account.dart';
import 'package:exercise_journal/src/screens/health_profile.dart';
import 'package:exercise_journal/src/screens/privacy_center.dart';
import 'package:exercise_journal/src/styles/base.dart';
import 'package:exercise_journal/src/styles/colours.dart';

// import 'package:exercise_journal/src/screens/settings.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:exercise_journal/src/widgets/custom_alert_dialog.dart';
import 'package:exercise_journal/src/widgets/loading_indicator.dart';
import 'package:exercise_journal/src/widgets/text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    return StreamBuilder<UserData>(
      stream: authBloc.user,
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == null) {
          return const LoadingIndicator(text: 'Setting up your profile page');
        }
        return Platform.isIOS
            ? CupertinoPageScaffold(
                backgroundColor: AppColours.background,
                child: pageBody(context, snapshot.data),
              )
            : Scaffold(
                body: pageBody(context, snapshot.data),
                backgroundColor: AppColours.background,
              );
      },
    );
  }

  Widget pageBody(BuildContext context, UserData? user) {
    var authBloc = Provider.of<AuthBloc>(context);
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 10.0,
            left: 100,
            right: 100,
          ),
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
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            user!.userName == '' ? 'Anonymous' : user.userName,
            style: TextStyle(
              fontSize: 34.0,
              color: AppColours.title,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            child: Divider(
              color: AppColours.shadow,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.solidEnvelope,
                color: AppColours.textBody,
              ),
              const SizedBox(width: 10),
              AutoSizeText(
                user.email == '' ? 'Anonymous' : user.email,
                minFontSize: 16.0,
                maxFontSize: 20.0,
                style: TextStyles.body,
              ),
            ],
          ),
        ),
        AppButton(
          buttonText: 'Health Profile',
          buttonType: ButtonType.primary,
          onPressed: () => Navigator.of(context).pushNamed(HealthProfile.id),
        ),
        // AppButton(
        //   buttonText: 'Settings',
        //   buttonType: ButtonType.primary,
        //   onPressed: () => Navigator.of(context).pushNamed(Settings.id),
        // ),
        AppButton(
          buttonText: 'Privacy Center',
          buttonType: ButtonType.primary,
          onPressed: () => Navigator.of(context).pushNamed(PrivacyCenter.id),
        ),
        StreamBuilder<String>(
          stream: authBloc.email,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              if (Platform.isIOS) {
                return CupertinoButton(
                  child: Text(
                    'Sign Out',
                    style: TextStyles.body,
                  ),
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) => CustomAlertDialog(
                        title: 'Signing out',
                        description: 'Are you sure you want to sign out?',
                        primaryButtonText: 'Cancel',
                        primaryButton: () => Navigator.of(context).pop(),
                        secondaryButtonText: 'Yes',
                        secondaryButton: () => authBloc.signOut(),
                      ),
                    );
                  },
                );
              } else {
                return TextButton(
                  child: Text(
                    'Sign Out',
                    style: TextStyles.body,
                  ),
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) => CustomAlertDialog(
                        title: 'Signing out',
                        description: 'Are you sure you want to sign out?',
                        primaryButtonText: 'Cancel',
                        primaryButton: () => Navigator.of(context).pop(),
                        secondaryButtonText: 'Yes',
                        secondaryButton: () => authBloc.signOut(),
                      ),
                    );
                  },
                );
              }
            } else {
              return PlainTextButton(
                buttonText: 'SignOut',
                onPressed: () => authBloc.signOut(),
              );
            }
          },
        ),
        StreamBuilder<String>(
          stream: authBloc.email,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              if (Platform.isIOS) {
                return CupertinoButton(
                  child: Text(
                    'Delete Account',
                    style: TextStyles.error,
                  ),
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) => CustomAlertDialog(
                        title: 'Deleting Account',
                        description:
                            'Are you sure you want to delete your account?',
                        primaryButtonText: 'Cancel',
                        primaryButton: () => Navigator.of(context).pop(),
                        secondaryButtonText: 'Yes',
                        secondaryButton: () =>
                            Navigator.of(context).pushNamed(DeleteAccount.id),
                      ),
                    );
                  },
                );
              } else {
                return TextButton(
                  child: Text(
                    'Delete Account',
                    style: TextStyles.error,
                  ),
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) => CustomAlertDialog(
                        title: 'Deleting Account',
                        description:
                            'Are you sure you want to delete your account?',
                        primaryButtonText: 'Cancel',
                        primaryButton: () => Navigator.of(context).pop(),
                        secondaryButtonText: 'Yes',
                        secondaryButton: () =>
                            Navigator.of(context).pushNamed(DeleteAccount.id),
                      ),
                    );
                  },
                );
              }
            } else {
              return PlainTextButton(
                buttonText: 'Delete Account',
                onPressed: () =>
                    Navigator.of(context).pushNamed(DeleteAccount.id),
              );
            }
          },
        ),
        Center(
          child: StreamBuilder<String>(
            stream: authBloc.accountType,
            builder: (context, snapshot) {
              List<Widget> widgetList = [];

              widgetList.add(
                AutoSizeText(
                  'Account Type: ${snapshot.data ?? ''}',
                  minFontSize: 16.0,
                  maxFontSize: 20.0,
                  style: TextStyles.body,
                ),
              );

              if (snapshot.data == 'Free') {
                widgetList.add(
                  FutureBuilder<dynamic>(
                    future: Provider.of<AdMobBloc>(context).getBannerAd(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            height: 60,
                            child: AdWidget(
                              ad: snapshot.data as AdWithView,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 60,
                        );
                      }
                    },
                  ),
                );
              }

              return Column(
                children: widgetList,
              );
            },
          ),
        ),
      ],
    );
  }
}
