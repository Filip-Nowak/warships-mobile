import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:warships_mobile/components/Button.dart';
import 'package:warships_mobile/components/TimerWidet.dart';
import 'package:warships_mobile/game/BoardController.dart';
import 'package:warships_mobile/newBoards/Board.dart';
import 'package:warships_mobile/newBoards/ConsoleBoard.dart';

import '../newBoards/BoardWidget.dart';

class ConsolePanel extends StatefulWidget {
  const ConsolePanel(
      {super.key,
      required this.setMode,
      required this.controller,
      required this.handleShoot});

  final void Function(bool) setMode;
  final BoardController controller;
  final Function handleShoot;

  @override
  State<ConsolePanel> createState() => _ConsolePanelState();
}

class _ConsolePanelState extends State<ConsolePanel> {
  double distance = 0;
  bool mode = false;
  bool playerTurn=false;
  ConsoleBoard board = ConsoleBoard(400);

  @override
  void initState() {
    super.initState();

    board.changeState = (Function callback) {
      setState(() {
        callback();
      });
    };

    widget.controller.setBoard = (Board board) {
      setState(() {
        print("setting board");
        this.board.board = board;
        this.board.widget =
            BoardWidget(size: 400, getFields: this.board.getFields);
      });
    };
    widget.controller.getBoardManager = () {
      return board;
    };
    widget.controller.setMode = (bool mode) {
      setState(() {
        this.mode = mode;
      });
    };
    widget.controller.setPlayerTurn=(bool turn){
      playerTurn=turn;
      if(turn){
        setState(() {
          mode=true;
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: mode ? 0 : -500,
      left: MediaQuery.of(context).size.width / 2 - 210,
      child: GestureDetector(
        onVerticalDragDown: (details) {
          distance = 0;
        },
        onVerticalDragUpdate: (details) {
          distance += details.delta.dy;
        },
        onVerticalDragEnd: (details) {
          if(!playerTurn) {
            if (distance > 100) {
              widget.setMode(false);
            } else if (distance < -100) {
              widget.setMode(true);
            }
          }
        },
        child: Container(
          width: 420,
          height: 600,
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
                    size: 50,
                    time: 0,
                  )),
              SizedBox(
                height: 5,
              ),
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2,color: playerTurn?Colors.green:Colors.black)
                  ),
                  child: board.widget),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 350,
                  height: 70,
                  color: Color.fromRGBO(1, 9, 3, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {},
                          iconSize: 50,
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.red,
                          )),
                      Container(
                          width: 270,
                          child: Button(
                            onPressed: () {
                              print("shoot");
                              widget.handleShoot(
                                  board.selected[0], board.selected[1]);
                            },
                            message: "shoot",
                            disabled: board.selected.isEmpty,
                            backGroundColor: board.selected.isEmpty?Color.fromRGBO(29, 79, 2, 0.5):Color.fromRGBO(29, 79, 2, 1.0),
                          ))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
