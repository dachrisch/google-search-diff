import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin TimerMixin<T extends StatefulWidget> on State<T> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initTimer();
  }

  void initTimer() async {
    final prefs = await SharedPreferences.getInstance();
    int refreshRate =
        prefs.getInt('refreshEvery') ?? 60; // Default to 60 seconds if not set
    timer = Timer.periodic(
        Duration(seconds: refreshRate), (Timer t) => onTimerTick());
  }

  void onTimerTick() {
    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
