import 'package:exercise_journal/src/styles/colours.dart';
import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';

class ActiveDayPicker extends StatefulWidget {
  final List<bool> initVal;
  final Function onChange;

  const ActiveDayPicker({
    super.key,
    required this.initVal,
    required this.onChange,
  });

  @override
  State<ActiveDayPicker> createState() => _ActiveDayPickerState();
}

class _ActiveDayPickerState extends State<ActiveDayPicker> {
  List<bool> _activeDays = List.filled(7, false);
  UnfocusDisposition disposition = UnfocusDisposition.scope;

  String intDayToEnglish(int day) {
    if (day % 7 == DateTime.monday % 7) return 'Monday';
    if (day % 7 == DateTime.tuesday % 7) return 'Tueday';
    if (day % 7 == DateTime.wednesday % 7) return 'Wednesday';
    if (day % 7 == DateTime.thursday % 7) return 'Thursday';
    if (day % 7 == DateTime.friday % 7) return 'Friday';
    if (day % 7 == DateTime.saturday % 7) return 'Saturday';
    if (day % 7 == DateTime.sunday % 7) return 'Sunday';
    throw '🐞 This should never have happened: $day';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initVal != []) {
      _activeDays = widget.initVal;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text("Which days you'll perform this workout?"),
          WeekdaySelector(
            selectedFillColor: AppColours.primaryButton,
            disabledColor: AppColours.disabled,
            color: AppColours.textBody,
            fillColor: AppColours.midground,
            onChanged: (day) {
              setState(() {
                _activeDays[day % 7] = !_activeDays[day % 7];
                widget.onChange(_activeDays);
                primaryFocus!.unfocus(disposition: disposition);
              });
            },
            selectedElevation: 15,
            elevation: 5,
            disabledElevation: 0,
            values: _activeDays,
          ),
        ],
      ),
    );
  }
}
