import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recetario_clase/styles/app_styles.dart';

class CookingTimer extends StatefulWidget {
  const CookingTimer({super.key, required this.minutes});

  final int minutes;

  @override
  State<CookingTimer> createState() => _CookingTimerState();
}

class _CookingTimerState extends State<CookingTimer> {
  late int secondsLeft;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    secondsLeft = widget.minutes * 60;
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      secondsLeft--;
      if (secondsLeft == 0) {
        timer.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = secondsLeft ~/ 60;
    final seconds = (secondsLeft % 60).toString().padLeft(2, '0');
    final Icon time = Icon(Icons.schedule, size: 32, color: AppStyles.primary);
    return Row(
      children: [
        time,
        AppStyles.smallSeparator,
        Text(
          '$minutes : $seconds',
          style: TextStyle(
            fontSize: 32,
            color: AppStyles.primary,
            fontWeight: .bold,
          ),
        ),
      ],
    );
  }
}
