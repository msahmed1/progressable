import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutHistory extends StatelessWidget {
  const WorkoutHistory({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: pageBody(),
      );
    }
    return Scaffold(
      body: pageBody(),
    );
  }

  Widget pageBody() {
    return const Center(
      child: Text('history'),
    );
  }
}
