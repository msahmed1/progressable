import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyButtons extends StatelessWidget {
  final bool showTandC;

  const PolicyButtons({super.key, required this.showTandC});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showTandC,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "By creating an account, you are agreeing to our\n",
            style: Theme.of(context).textTheme.bodyText1,
            children: [
              TextSpan(
                text: "Terms & Conditions ",
                style: const TextStyle(fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    return _launchURL(
                      "https://www.iubenda.com/terms-and-conditions/13709969",
                    );
                    // showModal(
                    //   context: context,
                    //   configuration: const FadeScaleTransitionConfiguration(),
                    //   builder: (context) {
                    //     return PolicyDialog(
                    //       mdFileName: 'terms_and_conditions.md',
                    //     );
                    //   },
                    // );
                  },
              ),
              const TextSpan(text: "and "),
              TextSpan(
                text: "Privacy Policy.",
                style: const TextStyle(fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    return _launchURL(
                      "https://www.iubenda.com/privacy-policy/13709969",
                    );
                    // showModal(
                    //   context: context,
                    //   builder: (context) {
                    //     return PolicyDialog(
                    //       mdFileName: 'privacy_policy.md',
                    //     );
                    //   },
                    // );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    await canLaunchUrl(uri)
        ? await launchUrl(uri)
        : throw 'could not launch the URL';
  }
}
