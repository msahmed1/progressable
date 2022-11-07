import 'package:exercise_journal/src/styles/base.dart';
import 'package:exercise_journal/src/styles/buttons.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:exercise_journal/src/styles/text.dart';
import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  secondary,
  tertiary,
  disabled,
}

class AppButton extends StatefulWidget {
  final String buttonText;
  final ButtonType buttonType;
  final void Function() onPressed;

  const AppButton({
    super.key,
    required this.buttonText,
    required this.buttonType,
    required this.onPressed,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    TextStyle fontStyle;
    Color buttonColor;

    switch (widget.buttonType) {
      case ButtonType.primary:
        fontStyle = TextStyles.buttonText;
        buttonColor = AppColours.primaryButton;
        break;
      case ButtonType.secondary:
        fontStyle = TextStyles.buttonText;
        buttonColor = AppColours.secondaryButton;
        break;
      case ButtonType.tertiary:
        fontStyle = TextStyles.buttonText;
        buttonColor = AppColours.tertiaryButton;
        break;
      case ButtonType.disabled:
        fontStyle = TextStyles.buttonText;
        buttonColor = AppColours.disabled;
        break;
      default:
        fontStyle = TextStyles.buttonText;
        buttonColor = AppColours.primaryButton;
        break;
    }

    return AnimatedContainer(
      padding: EdgeInsets.only(
        top: pressed
            ? BaseStyles.listFieldVertical + BaseStyles.animationOffset
            : BaseStyles.listFieldVertical,
        bottom: pressed
            ? BaseStyles.listFieldVertical - BaseStyles.animationOffset
            : BaseStyles.listFieldVertical,
        left: BaseStyles.listFieldHorizontal,
        right: BaseStyles.listFieldHorizontal,
      ),
      duration: const Duration(milliseconds: 20),
      child: GestureDetector(
        child: Container(
          height: ButtonStyles.buttonHeight,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(
              BaseStyles.borderRadius,
            ),
            boxShadow:
                pressed ? BaseStyles.boxShadowPressed : BaseStyles.boxShadow,
          ),
          child: Center(
            child: Text(
              widget.buttonText,
              style: fontStyle,
            ),
          ),
        ),
        onTapDown: (details) {
          setState(() {
            if (widget.buttonType != ButtonType.disabled) pressed = !pressed;
          });
        },
        onTapUp: (details) {
          setState(() {
            if (widget.buttonType != ButtonType.disabled) pressed = !pressed;
          });
        },
        onTap: () {
          if (widget.buttonType != ButtonType.disabled) {
            widget.onPressed();
          }
        },
      ),
    );
  }
}
