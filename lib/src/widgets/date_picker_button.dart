//#This widget is not used as it was intended for choosing training cycle duration

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:sport_journal/src/styles/base.dart';
// import 'package:sport_journal/src/styles/buttons.dart';
// import 'package:sport_journal/src/styles/colours.dart';
// import 'package:sport_journal/src/styles/text.dart';
//
// class AppDatePicker extends StatelessWidget {
//   final bool isIOS;
//   final dynamic initialDate;
//   final void Function(DateTime) onChanged;
//
//   const AppDatePicker(
//       {Key? key,
//       required this.isIOS,
//       this.initialDate,
//       required this.onChanged})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: BaseStyles.listPadding,
//       child: Container(
//         height: ButtonStyles.buttonHeight,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(
//                 color: AppColours.primaryButton, width: BaseStyles.borderWidths),
//             borderRadius:
//                 BorderRadius.all(Radius.circular(BaseStyles.borderRadius)),
//             boxShadow: const [
//               BoxShadow(
//                 blurRadius: 2,
//                 color: Colors.grey,
//                 offset: Offset(1, 2),
//               )
//             ]),
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Center(
//           child: GestureDetector(
//             child: initialDate == null
//                 ? Text(
//                     'Select a start date? ',
//                     style: TextStyles.suggestion,
//                   )
//                 : Text(
//                     'start date: ${DateFormat('yMd').format(initialDate)}',
//                     style: TextStyles.body,
//                   ),
//             onTap: () {
//               isIOS
//                   ? _cupertinoSelectDate(context)
//                   : _materialSelectDate(context);
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   _materialSelectDate(BuildContext context) async {
//     final now = DateTime.now();
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: initialDate ?? now,
//         firstDate: DateTime(now.year - 10),
//         lastDate: DateTime(now.year + 10));
//     if (picked != null && picked != initialDate) {
//       onChanged(picked);
//     }
//   }
//
//   _cupertinoSelectDate(BuildContext context) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (_) {
//         final now = DateTime.now();
//         return Container(
//           height: 200.0,
//           color: Colors.white,
//           child: CupertinoDatePicker(
//             mode: CupertinoDatePickerMode.date,
//             initialDateTime: initialDate ?? now,
//             minimumDate: DateTime(now.year - 10),
//             maximumDate: DateTime(now.year + 10),
//             onDateTimeChanged: onChanged,
//           ),
//         );
//       },
//     );
//   }
// }
