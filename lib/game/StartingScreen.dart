import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warships_mobile/components/Label.dart';
import 'package:warships_mobile/components/Modal.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({super.key, required this.players});

  final List<String> players;

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  int time = 5;
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Modal(
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                  width: 120,
                  child: Center(
                    child: Label(
                      widget.players[0],
                      fontSize: 120 ~/ widget.players[0].length,
                    ),
                  ),
                ),
                Container(
                  child: Label(
                    "vs",
                    fontSize: 20,
                  ),
                ),
                Container(
                  width: 120,
                  child: Center(
                    child: Label(
                      widget.players[1],
                      fontSize: 120 ~/ widget.players[1].length,
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: 50,
              ),
              Label("game starts in $time", fontSize: 20)
            ]))));
  }
}
