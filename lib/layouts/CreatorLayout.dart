import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:warships_mobile/components/TimerWidet.dart';
import 'package:warships_mobile/creator/BottomPanel.dart';
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
  int selectedShip=0;
  List<int> shipsLeft=[1,2,3,4];
  CreatorBoard board=CreatorBoard(400);
  late StopWatch stopwatch;
  void addShip(){
    setState(() {
      board.setSelectedShip(0);
      shipsLeft[4-selectedShip]--;
      selectedShip=0;
    });
  }
  void changeShip(int newShip){
    setState(() {
      board.setSelectedShip(newShip);
      selectedShip=newShip;
      board.widget=BoardWidget(size: 400, getFields: board.getFields);
    });
  }
  void changeState(Function callback){
    setState(() {
      callback();
    });
  }
  void changeMode(bool mode){
    setState(() {
      board.removeMode=mode;
      board.widget=BoardWidget(size: board.widget.size, getFields: board.getFields);
    });
  }
  void start(){
    board.board.transformToSea();
    UserDetails.instance.submitShips(board.board,context);

  }
  @override
  void initState() {
    super.initState();
    board.setChangeState(changeState);
    board.setAddShip(addShip);
    board.setRemoveShip(removeShip);
    Online.instance.creator=true;
    if(Online.instance.creator){
      stopwatch=StopWatch(onTimeChange: onTimeChange, onTimeEnd: onTimeEnd);
      stopwatch.start(60);
    }
    Online.instance.addRoomMessageHandler("LAUNCH", (message) {
      stopwatch.timer.cancel();
      Navigator.pop(context);
      Navigator.pushNamed(context, "/game");
    });
  }
  void removeShip(int size){
    setState(() {
      shipsLeft[4-size]++;
    });
  }
  void cancel(){
    setState(() {
      board.cancel();
      board.widget=BoardWidget(size: 400, getFields: board.getFields);
    });
  }
  int time=0;
  void onTimeChange(int time){
    setState(() {
      this.time=time;
    });
  }
  void onTimeEnd(){
    print("end");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: board.removeMode?Color.fromRGBO(30, 0, 0, 1):Color.fromRGBO(0, 24, 1, 1),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Label("deploy ships", fontSize: 50),
              TimerWidget(size: 40,time:time),
              board.widget,
              SizedBox(height: 30,),
              BottomPanel(changeMode: changeMode, board: board,selectedShip:selectedShip,changeShip:changeShip, start: start, shipsLeft: shipsLeft,removeMode: board.removeMode, cancel: cancel,),
              SizedBox(height: 20,),

            ],
          ),
        ));

  }
}