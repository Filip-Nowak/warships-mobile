import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:warships_mobile/components/Label.dart';
import 'package:warships_mobile/components/Modal.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({super.key});

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  int time = 5;
  late Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    timer=Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        time--;
        if (time == 0) {
          timer.cancel();
        }
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Modal(child: Label("game starts in $time", fontSize: 40)));
  }
}
