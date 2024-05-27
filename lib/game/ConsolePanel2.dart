import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:warships_mobile/components/Button.dart';
import 'package:warships_mobile/components/TimerWidet.dart';
import 'package:warships_mobile/game/BoardController.dart';
import 'package:warships_mobile/models/Pos.dart';
import 'package:warships_mobile/newBoards/Board.dart';
import 'package:warships_mobile/newBoards/ConsoleBoard.dart';

import '../newBoards/BoardWidget.dart';
import '../utils/Multiplier.dart';

class ConsolePanel2 extends StatefulWidget {
  const ConsolePanel2(
      {super.key,
      required this.setMode,
      required this.handleShoot, required this.mode, required this.board, required this.playerTurn, required this.setPlayerTurn, required this.handleForfeit, required this.time});

  final void Function(bool) setMode;
  final Function handleShoot;
  final bool mode;
  final ConsoleBoard board;
  final bool playerTurn;
  final Function setPlayerTurn;
  final void Function() handleForfeit;
  final int time;
  @override
  State<ConsolePanel2> createState() => _ConsolePanel2State();
}

class _ConsolePanel2State extends State<ConsolePanel2> {
  double distance = 0;
  @override
  void initState() {
    super.initState();
  }


  void handleClick(int x,int y){
    setState(() {
      widget.setPlayerTurn(false);
      widget.board.disabled=true;
      widget.board.widget=BoardWidget(size: 350, getFields: widget.board.getFields);
      widget.handleShoot(Pos(x: x, y: y));
    });
  }

  @override
  Widget build(BuildContext context) {
    double multiplier=Multiplier.getMultiplier(context);
    return GestureDetector(
      onVerticalDragDown: (details) {
        distance = 0;
      },
      onVerticalDragUpdate: (details) {
        distance += details.delta.dy;
      },
      onVerticalDragEnd: (details) {
        if(!widget.playerTurn) {
          if (distance > 100) {
            widget.setMode(false);
          } else if (distance < -100) {
            widget.setMode(true);
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width*0.95,
        height: MediaQuery.of(context).size.height*0.7,
        color: Color.fromRGBO(66, 0, 0, 1),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Container(
                width: 200,
                color: Color.fromRGBO(1, 9, 3, 1),
                child: TimerWidget(
                  dangerZone: 4,
                  disabled:!widget.playerTurn,
                  size: (50*multiplier).toInt(),
                  time: widget.time,
                )),
            SizedBox(
              height: 5,
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2,color: widget.playerTurn?Colors.green:Colors.black)
                ),
                child: widget.board.widget),
            SizedBox(
              height: 20,
            ),
            Container(
                width: MediaQuery.of(context).size.width*0.95*0.9,
                height: 70,
                color: Color.fromRGBO(1, 9, 3, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: widget.handleForfeit,
                        iconSize: 50,
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.red,
                        )),
                    Container(
                        width: 220,
                        child: Button(
                          onPressed: () {
                            print("shoot");
                            handleClick(
                                widget.board.selected[0], widget.board.selected[1]);
                          },
                          message: "shoot",
                          disabled: !(widget.board.selected.isNotEmpty && widget.playerTurn),
                          backGroundColor: !(widget.board.selected.isNotEmpty && widget.playerTurn)?Color.fromRGBO(29, 79, 2, 0.5):Color.fromRGBO(29, 79, 2, 1.0),
                        ))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
