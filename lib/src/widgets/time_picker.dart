import 'package:exercise_journal/src/blocs/format_time.dart';
import 'package:exercise_journal/src/styles/base.dart';
import 'package:exercise_journal/src/styles/buttons.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/widgets/custom_input_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class TimePicker extends StatefulWidget {
  final String title;
  final bool isIOS;
  final Function onChange;
  final int duration;

  const TimePicker({
    super.key,
    required this.title,
    required this.isIOS,
    required this.onChange,
    required this.duration,
  });

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  int hour = 0;
  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    // TODO: implement initState
    hour = widget.duration != 0
        ? FormatTime().formattedTime(widget.duration)[0]
        : 0;

    minutes = widget.duration != 0
        ? FormatTime().formattedTime(widget.duration)[1]
        : 0;

    seconds = widget.duration != 0
        ? FormatTime().formattedTime(widget.duration)[2]
        : 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: BaseStyles.listPadding,
      child: GestureDetector(
        child: Container(
          height: ButtonStyles.buttonHeight,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColours.forground,
            border: Border.all(
              color: AppColours.primaryButton,
              width: BaseStyles.borderWidths,
            ),
            borderRadius:
                BorderRadius.all(Radius.circular(BaseStyles.borderRadius)),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: AppColours.shadow,
                offset: const Offset(1, 2),
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: widget.duration == 0
                ? Text(
                    widget.title,
                    style: TextStyles.suggestion,
                  )
                : Text(
                    FormatTime().displayTime(widget.duration),
                    style: TextStyles.body,
                  ),
          ),
        ),
        onTap: () {
          widget.isIOS
              ? _cupertinoSelectDate(context)
              : _materialSelectDate(context);
        },
      ),
    );
  }

  Future<Future> _materialSelectDate(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: CustomInputDialog(
              title: widget.title,
              formBody: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text('H'),
                      ),
                      NumberPicker(
                        value: hour,
                        minValue: 0,
                        maxValue: 23,
                        onChanged: (val) {
                          setState(() {
                            hour = val;
                          });
                        },
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text('M'),
                      ),
                      NumberPicker(
                        value: minutes,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (val) {
                          setState(() {
                            minutes = val;
                          });
                        },
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text('S'),
                      ),
                      NumberPicker(
                        value: seconds,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (val) {
                          setState(() {
                            seconds = val;
                          });
                        },
                      )
                    ],
                  )
                ],
              ),
              onSubmit: () =>
                  widget.onChange(hour * 3600 + minutes * 60 + seconds),
            ),
          );
        },
      ),
    );
  }

  void _cupertinoSelectDate(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return Container(
          height: 200.0,
          color: AppColours.forground,
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyles.body,
              ),
            ),
            child: CupertinoTimerPicker(
              initialTimerDuration: Duration(seconds: widget.duration),
              onTimerDurationChanged: (duration) =>
                  widget.onChange(duration.inSeconds),
              backgroundColor: AppColours.forground,
            ),
          ),
        );
      },
    );
  }
}
