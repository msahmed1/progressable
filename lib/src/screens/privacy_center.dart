import 'dart:io';

import 'package:exercise_journal/src/screens/licence_page.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyCenter extends StatelessWidget {
  static const String id = 'privacy_center';

  const PrivacyCenter({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: GestureDetector(
            child: Icon(
              CupertinoIcons.left_chevron,
              color: AppColours.primaryButton,
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          middle: Text(
            'Privacy Center',
            style: TextStyles.title,
          ),
          backgroundColor: AppColours.appBar,
        ),
        child: SafeArea(child: pageBody(context)),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: AppColours.primaryButton,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Privacy Center',
          style: TextStyles.title,
        ),
        backgroundColor: AppColours.appBar,
      ),
      body: SafeArea(child: pageBody(context)),
    );
  }

  Widget pageBody(BuildContext context) {
    return Column(
      children: [
        AppButton(
          buttonText: 'Terms & Conditions',
          buttonType: ButtonType.primary,
          onPressed: () => _launchURL(
            'https://www.iubenda.com/terms-and-conditions/13709969',
          ),
          //     showModal(
          //   context: context,
          //   configuration: const FadeScaleTransitionConfiguration(),
          //   builder: (context) {
          //     return PolicyDialog(
          //       mdFileName: 'terms_and_conditions.md',
          //     );
          //   },
          // ),
        ),
        AppButton(
          buttonText: 'Privacy Policy',
          buttonType: ButtonType.primary,
          onPressed: () =>
              _launchURL('https://www.iubenda.com/privacy-policy/13709969'),
          //     showModal(
          //   context: context,
          //   builder: (context) {
          //     return PolicyDialog(
          //       mdFileName: 'privacy_policy.md',
          //     );
          //   },
          // ),
        ),
        AppButton(
          buttonText: 'licenses',
          buttonType: ButtonType.primary,
          onPressed: () =>
              Navigator.of(context).pushNamed(LicensePageCustom.id),
        )
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    await canLaunchUrl(uri)
        ? await launchUrl(uri)
        : throw 'could not launch the URL';
  }
}
