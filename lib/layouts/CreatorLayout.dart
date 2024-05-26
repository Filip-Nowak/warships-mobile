import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:warships_mobile/components/TimerWidet.dart';
import 'package:warships_mobile/creator/BottomPanel.dart';
import 'package:warships_mobile/models/User.dart';
import 'package:warships_mobile/newBoards/BoardWidget.dart';
import 'package:warships_mobile/utils/Online.dart';
import 'package:warships_mobile/utils/UserDetails.dart';

import '../components/Label.dart';
import '../newBoards/CreatorBoard.dart';
import '../utils/StopWatch.dart';

class CreatorLayout extends StatefulWidget {
  const CreatorLayout({super.key});

  @override
  State<CreatorLayout> createState() => _CreatorLayoutState();
}

class _CreatorLayoutState extends State<CreatorLayout> {
  int selectedShip = 0;
  List<int> shipsLeft = [1, 2, 3, 4];
  CreatorBoard board = CreatorBoard(400);
  late StopWatch stopwatch =
      StopWatch(onTimeChange: onTimeChange, onTimeEnd: onTimeEnd);

  void addShip() {
    setState(() {
      board.setSelectedShip(0);
      shipsLeft[4 - selectedShip]--;
      selectedShip = 0;
    });
  }

  void changeShip(int newShip) {
    setState(() {
      board.setSelectedShip(newShip);
      selectedShip = newShip;
      board.widget = BoardWidget(size: 400, getFields: board.getFields);
    });
  }

  void changeState(Function callback) {
    setState(() {
      callback();
    });
  }

  void changeMode(bool mode) {
    setState(() {
      board.removeMode = mode;
      board.widget =
          BoardWidget(size: board.widget.size, getFields: board.getFields);
    });
  }

  void start() {
    board.board.transformToSea();
    if (UserDetails.instance.online) {
      setState(() {
        _isLoading = true;
      });
    }
    UserDetails.instance.submitShips(board.board, context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopwatch.stop();
  }

  @override
  void initState() {
    super.initState();
    board.setChangeState(changeState);
    board.setAddShip(addShip);
    board.setRemoveShip(removeShip);
    print(UserDetails.instance.online);
    if (UserDetails.instance.online) {
      print('xd');
      Online.instance.creator = true;
      if (Online.instance.creator) {
        stopwatch.start(60);
      }
      Online.instance.addRoomMessageHandler("LAUNCH", (message) {
        UserDetails.instance.submitted = false;
        setState(() {
          _isLoading = false;
        });
        stopwatch.stop();
        Navigator.pop(context);
        Navigator.pushNamed(context, "/game");
      });
    }
  }

  void removeShip(int size) {
    setState(() {
      shipsLeft[4 - size]++;
    });
  }

  void cancel() {
    setState(() {
      board.cancel();
      board.widget = BoardWidget(size: 400, getFields: board.getFields);
    });
  }

  bool _isLoading = false;
  int time = 0;

  void onTimeChange(int time) {
    setState(() {
      this.time = time;
    });
  }

  void onTimeEnd() {
    if (UserDetails.instance.submitted) {
      start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (xd) {
        if (xd) {
          return;
        }
        UserDetails.instance.back();
      },
      child: Scaffold(
          backgroundColor: board.removeMode
              ? Color.fromRGBO(30, 0, 0, 1)
              : Color.fromRGBO(0, 24, 1, 1),
          body: Stack(children: [
            SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: UserDetails.instance.back,
                            icon: Icon(
                              Icons.arrow_back,
                              size: 50,
                              color: Color.fromRGBO(143, 255, 0, 1.0),
                            ))
                      ],
                    ),
                    const Label("deploy ships", fontSize: 40),
                    TimerWidget(
                      size: 30,
                      time: time,
                      disabled: !UserDetails.instance.online,
                    ),
                    board.widget,
                    BottomPanel(
                      changeMode: changeMode,
                      board: board,
                      selectedShip: selectedShip,
                      changeShip: changeShip,
                      start: start,
                      shipsLeft: shipsLeft,
                      removeMode: board.removeMode,
                      cancel: cancel,
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              AbsorbPointer(
                child: Stack(
                  children: [
                    ModalBarrier(
                        dismissible: false,
                        color: Colors.black.withOpacity(0.8)),
                    Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Label(
                              "waiting for enemy",
                              fontSize: 50,
                            ),
                            CircularProgressIndicator(
                              color: Color.fromRGBO(143, 255, 0, 1.0),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
          ])),
    );

    ;
  }
}
