import 'package:exercise_journal/src/styles/base.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:exercise_journal/src/styles/textfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final bool isIOS;
  final String hintText;
  final TextInputType textInputType;
  final bool obscureText;
  final void Function(String) onChanged;
  final String errorText;
  final String initialText;
  final bool? update;

  const AppTextField({
    super.key,
    required this.isIOS,
    required this.hintText,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    required this.onChanged,
    required this.errorText,
    this.initialText = '',
    this.update,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _node;
  late bool displayCupertinoErrorBorder = false;
  late TextEditingController _controller;
  late String previousText = '';

  @override
  void initState() {
    _node = FocusNode();
    _controller = TextEditingController();
    if (widget.initialText != '') {
      _controller.text = widget.initialText;
    }
    _node.addListener(_handleFocusChange);
    displayCupertinoErrorBorder = false;

    super.initState();
  }

  void _handleFocusChange() {
    if (_node.hasFocus == false && widget.errorText != '') {
      displayCupertinoErrorBorder = true;
    } else {
      displayCupertinoErrorBorder = false;
    }

    widget.onChanged(_controller.text);
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);
    _node.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialText != '' && _controller.text.isEmpty) {
      _controller.text = widget.initialText;
    }
    if (widget.update ?? false) {
      _controller.text = widget.initialText;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: BaseStyles.listFieldHorizontal,
        vertical: BaseStyles.listFieldVertical,
      ),
      child: textField(),
    );
  }

  Widget textField() {
    // Build IOS and Android text widgets
    if (widget.isIOS) {
      return Column(
        children: <Widget>[
          CupertinoTextField(
            keyboardType: widget.textInputType,
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            placeholder: widget.hintText,
            placeholderStyle: TextFieldsStyles.placeHolder,
            style: TextFieldsStyles.text,
            textAlign: TextFieldsStyles.textAlign,
            decoration: displayCupertinoErrorBorder
                ? TextFieldsStyles.cupertinoErrorDecoration
                : TextFieldsStyles.cupertinoDecoration,
            obscureText: widget.obscureText,
            onChanged: widget.onChanged,
            focusNode: _node,
            controller: _controller,
          ),
          if (widget.errorText != '')
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    widget.errorText,
                    style: TextStyles.error,
                  )
                ],
              ),
            )
          else
            Container(),
        ],
      );
    } else {
      return TextField(
        keyboardType: widget.textInputType,
        cursorColor: TextFieldsStyles.cursorColor,
        style: TextFieldsStyles.text,
        textAlign: TextFieldsStyles.textAlign,
        decoration: TextFieldsStyles.materialDecoration(
          widget.hintText,
          widget.errorText,
        ),
        obscureText: widget.obscureText,
        controller: _controller,
        onChanged: widget.onChanged,
      );
    }
  }
}
