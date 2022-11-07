import 'dart:io';

import 'package:exercise_journal/src/blocs/ad_mob_bloc.dart';
import 'package:exercise_journal/src/blocs/format_time.dart';
import 'package:exercise_journal/src/blocs/journaling_bloc.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:exercise_journal/src/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class SummaryScreen extends StatefulWidget {
  static const String id = 'summary_screen';
  final int time;

  const SummaryScreen({super.key, required this.time});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(
                "Workout Summary",
                // ignore: avoid_redundant_argument_values
                style: TextStyles.title.copyWith(fontSize: null),
              ),
              // leading: Container(width: 0),
              leading: GestureDetector(
                child: Icon(
                  CupertinoIcons.clear_thick,
                  color: AppColours.primaryButton,
                ),
                onTap: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 3);
                },
              ),
              backgroundColor: AppColours.appBar,
            ),
            child: pageBody(context),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Workout Summary',
                // ignore: avoid_redundant_argument_values
                style: TextStyles.title.copyWith(fontSize: null),
              ),
              leading: IconButton(
                icon: const Icon(FontAwesomeIcons.xmark),
                onPressed: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 3);
                },
              ),
              backgroundColor: AppColours.appBar,
            ),
            body: pageBody(context),
          );
  }

  Widget pageBody(BuildContext context) {
    JournalingBloc journalBloc = Provider.of<JournalingBloc>(context);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          StreamBuilder<double>(
            stream: journalBloc.totalVolume,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Platform.isIOS ? CupertinoIcons.timer : Icons.timer,
                            size: 40.0,
                            color: AppColours.primaryButton,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Workout Duration: ',
                            style: TextStyles.title,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            FormatTime().displayTime(widget.time),
                            style: TextStyles.title,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.scale,
                            size: 40.0,
                            color: AppColours.primaryButton,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Total Volume: ',
                            style: TextStyles.title,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${snapshot.data}',
                                style: TextStyles.title,
                              ),
                              Text(
                                'kg',
                                style: TextStyles.suggestion,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const Expanded(
                  child: Center(
                    child: LoadingIndicator(
                      text: 'Loading your workout summary',
                    ),
                  ),
                );
              }
            },
          ),
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
          AppButton(
            buttonText: 'Exit',
            buttonType: ButtonType.primary,
            onPressed: () {
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 3);
            },
          ),
        ],
      ),
    );
  }
}
