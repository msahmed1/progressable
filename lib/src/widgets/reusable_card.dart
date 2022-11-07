import 'package:exercise_journal/src/styles/colours.dart';
import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard({
    super.key,
    required this.backgroundColor,
    required this.cardChild,
    this.onPress,
  });

  final Color backgroundColor;
  final Widget cardChild;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColours.shadow,
              blurRadius: 15.0,
              offset: const Offset(0.0, 0.75),
            )
          ],
          color: backgroundColor,
        ),
        child: cardChild,
      ),
    );
  }
}
