import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:warships_mobile/components/Label.dart';
import 'package:warships_mobile/components/Modal.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({super.key, required this.players, required this.starts,});

  final List<String> players;
  final bool starts;
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
                Column(
                  children: [SizedBox(
                    width: 120,
                    child: Center(
                      child: Label(
                        widget.players[0],
                        fontSize: widget.players[1].length<5?40:120 ~/ widget.players[0].length,
                      ),
                    ),
                  ),
                  widget.starts?Container(height:30,child: Label("starts", fontSize: 20,color: Color.fromRGBO(143, 255, 0, 0.5),)):SizedBox(height: 30,)
                  ],
                ),
                Container(
                  child: Label(
                    "vs",
                    fontSize: 20,
                  ),
                ),
                Column(
                  children: [SizedBox(
                    width: 120,
                    child: Center(
                      child: Label(
                        widget.players[1],
                        fontSize: widget.players[1].length<5?40:120 ~/ widget.players[1].length,

                      ),
                    ),
                  ),
                    !widget.starts?Container(height:30,child: Label("starts", fontSize: 20,color: Color.fromRGBO(143, 255, 0, 0.5),)):SizedBox(height: 30,)
                ]),
              ]),
              SizedBox(
                height: 50,
              ),
              Label("game starts in $time", fontSize: 20)
            ]))));
  }
}
