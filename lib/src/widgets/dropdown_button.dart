import 'dart:io';

import 'package:exercise_journal/src/styles/base.dart';
import 'package:exercise_journal/src/styles/buttons.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDropdownButton extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final String value;
  final Function(String) onChanged;

  const AppDropdownButton({
    super.key,
    required this.items,
    required this.hintText,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Padding(
        padding: BaseStyles.listPadding,
        child: GestureDetector(
          child: Container(
            height: ButtonStyles.buttonHeight,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColours.midground,
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
              child: (value == '')
                  ? Text(hintText, style: TextStyles.suggestion)
                  : Text(value, style: TextStyles.body),
            ),
          ),
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return _selectIOS(context, items);
              },
            );
          },
        ),
      );
    } else {
      return DropdownButtonHideUnderline(
        child: Padding(
          padding: BaseStyles.listPadding,
          child: Container(
            height: ButtonStyles.buttonHeight,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColours.midground,
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
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Center(
              child: DropdownButton<String>(
                isExpanded: true,
                borderRadius: BorderRadius.all(
                  Radius.circular(BaseStyles.borderRadius),
                ),
                dropdownColor: AppColours.forground,
                items: buildMaterialItems(items),
                value: value == '' ? null : value,
                elevation: 16,
                hint: Text(
                  hintText,
                  style: TextStyles.suggestion,
                  textAlign: TextAlign.center,
                ),
                onChanged: (value) => onChanged(value!),
                style: TextStyles.body,
                alignment: AlignmentDirectional.center,
              ),
            ),
          ),
        ),
      );
    }
  }

  List<DropdownMenuItem<String>> buildMaterialItems(List<String> items) {
    return items
        .map<DropdownMenuItem<String>>(
          (item) => DropdownMenuItem<String>(
            value: item,
            child: Center(
              child: Text(
                item,
                style: TextStyles.body,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _selectIOS(BuildContext context, List<String> items) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        color: AppColours.forground,
        height: 200.0,
        child: CupertinoTheme(
          data: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              dateTimePickerTextStyle: TextStyles.body,
            ),
          ),
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: items.indexWhere((item) => item == value),
            ),
            itemExtent: 45.0,
            diameterRatio: 1.0,
            onSelectedItemChanged: (int index) => onChanged(items[index]),
            backgroundColor: AppColours.forground,
            children: buildCupertinoItems(items),
          ),
        ),
      ),
    );
  }

  List<Widget> buildCupertinoItems(List<String> items) {
    return items
        .map(
          (item) => Center(
            child: Text(
              item,
              textAlign: TextAlign.center,
              style: TextStyles.body,
            ),
          ),
        )
        .toList();
  }
}
