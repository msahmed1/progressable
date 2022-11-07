import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:exercise_journal/src/blocs/auth_bloc.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/app_textfield.dart';
import 'package:exercise_journal/src/widgets/button.dart';
import 'package:exercise_journal/src/widgets/reusable_card.dart';
import 'package:exercise_journal/src/widgets/rounded_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HealthProfile extends StatefulWidget {
  static const String id = 'health_profiler';

  const HealthProfile({super.key});

  @override
  State<HealthProfile> createState() => _HealthProfileState();
}

class _HealthProfileState extends State<HealthProfile> {
  bool updateText = false;
  UnfocusDisposition disposition = UnfocusDisposition.scope;

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);

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
            'Health Profile',
            style: TextStyles.title,
          ),
          backgroundColor: AppColours.background,
        ),
        child: SafeArea(child: pageBody(context, authBloc)),
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
          'Health Profile',
          style: TextStyles.title,
        ),
      ),
      body: SafeArea(child: pageBody(context, authBloc)),
    );
  }

  Widget pageBody(BuildContext context, AuthBloc authBloc) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        // StreamBuilder<String>(
        //     stream: authBloc.gender,
        //     builder: (context, snapshot) {
        //       return Row(
        //         children: <Widget>[
        //           Expanded(
        //             child: ReusableCard(
        //               onPress: () {
        //                 authBloc.changeGender('male');
        //               },
        //               backgroundColor: snapshot.data == 'male'
        //                   ? AppColours.darkBlue
        //                   : AppColours.primary,
        //               cardChild: icontContent(
        //                 icon: FontAwesomeIcons.mars,
        //                 lable: 'MALE',
        //                 contentColor: snapshot.data == 'male'
        //                     ? Colors.white
        //                     : Colors.black,
        //               ),
        //             ),
        //           ),
        //           Expanded(
        //             child: ReusableCard(
        //               onPress: () {
        //                 authBloc.changeGender('neutral');
        //               },
        //               backgroundColor:
        //                   snapshot.data == 'neutral' || snapshot.data == ''
        //                       ? AppColours.darkBlue
        //                       : AppColours.primary,
        //               cardChild: icontContent(
        //                 icon: FontAwesomeIcons.transgenderAlt,
        //                 lable: 'Neutral',
        //                 contentColor:
        //                     snapshot.data == 'neutral' || snapshot.data == ''
        //                         ? Colors.white
        //                         : Colors.black,
        //               ),
        //             ),
        //           ),
        //           Expanded(
        //             child: ReusableCard(
        //               onPress: () {
        //                 authBloc.changeGender('female');
        //               },
        //               backgroundColor: snapshot.data == 'female'
        //                   ? AppColours.darkBlue
        //                   : AppColours.primary,
        //               cardChild: icontContent(
        //                 icon: FontAwesomeIcons.venus,
        //                 lable: 'FEMALE',
        //                 contentColor: snapshot.data == 'female'
        //                     ? Colors.white
        //                     : Colors.black,
        //               ),
        //             ),
        //           ),
        //         ],
        //       );
        //     }),
        StreamBuilder<double>(
          stream: authBloc.height,
          builder: (context, snapshot) {
            return ReusableCard(
              backgroundColor: AppColours.forground,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Height in cm?',
                    style: TextStyles.body,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RoundIconButton(
                          icon: FontAwesomeIcons.minus,
                          onPressed: () {
                            primaryFocus!.unfocus(disposition: disposition);
                            if (snapshot.hasData) {
                              if (snapshot.data! >= 121) {
                                authBloc.changeHeight('${snapshot.data! - 1}');
                              } else {
                                authBloc.changeHeight('220');
                              }
                            } else {
                              authBloc.changeHeight('220');
                            }
                            updateText = true;
                          },
                        ),
                        Expanded(
                          child: AppTextField(
                            isIOS: Platform.isIOS,
                            hintText: 'Weight in kg?',
                            initialText: snapshot.hasData
                                ? (snapshot.data == 0
                                    ? ''
                                    : snapshot.data.toString())
                                : '',
                            textInputType: TextInputType.number,
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : '',
                            onChanged: (String keyBoardEvent) {
                              authBloc.changeHeight(keyBoardEvent);
                              updateText = false;
                            },
                            update: updateText,
                          ),
                        ),
                        RoundIconButton(
                          icon: FontAwesomeIcons.plus,
                          onPressed: () {
                            primaryFocus!.unfocus(disposition: disposition);
                            if (snapshot.hasData) {
                              if (snapshot.data! <= 219) {
                                authBloc.changeHeight('${snapshot.data! + 1}');
                              } else {
                                authBloc.changeHeight('120');
                              }
                            } else {
                              authBloc.changeHeight('120');
                            }
                            updateText = true;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
            // return ReusableCard(
            //   backgroundColor: AppColours.forground,
            //   cardChild: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     children: <Widget>[
            //       Text(
            //         'Height',
            //         style: TextStyles.body,
            //         textAlign: TextAlign.center,
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.baseline,
            //         textBaseline: TextBaseline.alphabetic,
            //         children: <Widget>[
            //           Text(
            //             snapshot.hasData ? snapshot.data.toString() : '---',
            //             style: TextStyles.title,
            //           ),
            //           Text(
            //             ' cm',
            //             style: TextStyles.suggestion,
            //           ),
            //         ],
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //         child: AdaptiveSlider(
            //           minVal: 120,
            //           maxVal: 220,
            //           initVal: 170,
            //           value: snapshot.hasData ? snapshot.data! : 170.0,
            //           onChange: authBloc.changeHeight,
            //         ),
            //       ),
            //     ],
            //   ),
            // );
          },
        ),
        StreamBuilder<double>(
          stream: authBloc.weight,
          builder: (context, snapshot) {
            return ReusableCard(
              backgroundColor: AppColours.forground,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Weight kg?',
                    style: TextStyles.body,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RoundIconButton(
                          icon: FontAwesomeIcons.minus,
                          onPressed: () {
                            primaryFocus!.unfocus(disposition: disposition);
                            if (snapshot.hasData) {
                              if (snapshot.data! >= 41) {
                                authBloc.changeWeight('${snapshot.data! - 1}');
                              } else {
                                authBloc.changeWeight('200');
                              }
                            } else {
                              authBloc.changeWeight('200');
                            }
                            updateText = true;
                          },
                        ),
                        Expanded(
                          child: AppTextField(
                            isIOS: Platform.isIOS,
                            hintText: 'Weight in kg?',
                            initialText: snapshot.hasData
                                ? (snapshot.data == 0
                                    ? ''
                                    : snapshot.data.toString())
                                : '',
                            textInputType: TextInputType.number,
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : '',
                            onChanged: (String keyBoardEvent) {
                              authBloc.changeWeight(keyBoardEvent);
                              updateText = false;
                            },
                            update: updateText,
                          ),
                        ),
                        RoundIconButton(
                          icon: FontAwesomeIcons.plus,
                          onPressed: () {
                            primaryFocus!.unfocus(disposition: disposition);
                            if (snapshot.hasData) {
                              if (snapshot.data! <= 199) {
                                authBloc.changeWeight('${snapshot.data! + 1}');
                              } else {
                                authBloc.changeWeight('40');
                              }
                            } else {
                              authBloc.changeWeight('40');
                            }
                            updateText = true;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
            // return Row(
            //   children: <Widget>[
            //     Expanded(
            //       child: ReusableCard(
            //         backgroundColor: AppColours.forground,
            //         cardChild: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.stretch,
            //           children: <Widget>[
            //             Text(
            //               'Weight',
            //               style: TextStyles.body,
            //               textAlign: TextAlign.center,
            //             ),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               crossAxisAlignment: CrossAxisAlignment.baseline,
            //               textBaseline: TextBaseline.alphabetic,
            //               children: <Widget>[
            //                 Text(
            //                   snapshotValue.toString(),
            //                   style: TextStyles.title,
            //                 ),
            //                 Text(
            //                   ' kg',
            //                   style: TextStyles.suggestion,
            //                 ),
            //               ],
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //               child: AdaptiveSlider(
            //                 minVal: 40,
            //                 maxVal: 200,
            //                 initVal: 70,
            //                 value: snapshotValue,
            //                 onChange: (double weight) {
            //                   authBloc.changeWeight(weight.toString());
            //                   updateText = true;
            //                 },
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     )
            //   ],
            // );
          },
        ),
        StreamBuilder<int>(
          stream: authBloc.age,
          builder: (context, snapshot) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    backgroundColor: AppColours.forground,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Age',
                          style: TextStyles.body,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RoundIconButton(
                                icon: FontAwesomeIcons.minus,
                                onPressed: () {
                                  if (snapshot.hasData) {
                                    if (snapshot.data! > 13) {
                                      authBloc.changeAge(snapshot.data! - 1);
                                    } else {
                                      authBloc.changeAge(30);
                                    }
                                  } else {
                                    authBloc.changeAge(30);
                                  }
                                },
                              ),
                              Row(
                                textBaseline: TextBaseline.alphabetic,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AutoSizeText(
                                    snapshot.hasData
                                        ? snapshot.data.toString()
                                        : '--',
                                    minFontSize: 28.0,
                                    style: TextStyles.body,
                                  ),
                                ],
                              ),
                              RoundIconButton(
                                icon: FontAwesomeIcons.plus,
                                onPressed: () {
                                  if (snapshot.hasData) {
                                    if (snapshot.data! < 80) {
                                      authBloc.changeAge(snapshot.data! + 1);
                                    } else {
                                      authBloc.changeAge(30);
                                    }
                                  } else {
                                    authBloc.changeAge(30);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
        ReusableCard(
          backgroundColor: AppColours.forground,
          cardChild: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'BMI Result',
                style: TextStyles.body,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  StreamBuilder<bool>(
                    stream: authBloc.calcBmi,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return Text(
                          snapshot.hasData ? authBloc.calculateBMI() : '',
                          style: TextStyles.title,
                        );
                      }
                      return const Text('');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        StreamBuilder<bool>(
          stream: authBloc.isBMIValid,
          builder: (context, snapshot) {
            return AppButton(
              buttonText: 'Save',
              buttonType: snapshot.data == true
                  ? ButtonType.primary
                  : ButtonType.disabled,
              onPressed: () {
                authBloc.saveHealthData();
                Navigator.of(context).pop();
              },
            );
          },
        )
      ],
    );
  }
}
