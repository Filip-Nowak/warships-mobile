// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:warships_mobile/game/ConsolePanel2.dart';
// import 'package:warships_mobile/newBoards/SeaBoard.dart';
// import 'package:warships_mobile/utils/UserDetails.dart';
//
// import '../components/GameInfo.dart';
// import '../components/Label.dart';
//
// class GameLayout extends StatefulWidget {
//   const GameLayout({super.key});
//
//   @override
//   State<GameLayout> createState() => _GameLayoutState();
// }
//
// class _GameLayoutState extends State<GameLayout> {
//   String message="";
//   SeaBoard playerBoard=SeaBoard(400, UserDetails.instance.board);
//   bool mode=false;
//   void setMode(bool mode){
//     setState(() {
//       this.mode=mode;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body:
//     Container(
//       color: Color.fromRGBO(30, 109, 226, 1),
//       child: Stack(children: [
//         Column(children: [
//           GameInfo(
//             message: message,
//           ),
//         Container(
//           width: double.infinity,
//           color: Color.fromRGBO(30, 109, 226, 1),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 60,
//               ),
//               Label("your ships",
//                   fontSize: 50, color: Color.fromRGBO(5, 50, 128, 1)),
//               SizedBox(
//                 height: 20,
//               ),
//               playerBoard.widget,
//             ],
//           ),
//         ),
//         ]),
//         ConsolePanel2(setMode: setMode, handleShoot: (){}, mode: mode,)
//       ]),
//     )
//
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warships_mobile/components/Button.dart';
import 'package:warships_mobile/components/Modal.dart';
import 'package:warships_mobile/game/GameFunctions.dart';
import 'package:warships_mobile/newBoards/BoardWidget.dart';
import 'package:warships_mobile/utils/UserDetails.dart';

import '../components/GameInfo.dart';
import '../components/Label.dart';
import '../game/ConsolePanel.dart';
import '../game/ConsolePanel2.dart';
import '../game/EndingScreen.dart';
import '../game/StartingScreen.dart';
import '../models/Pos.dart';
import '../newBoards/Board.dart';
import '../newBoards/ConsoleBoard.dart';
import '../newBoards/SeaBoard.dart';

class GameLayout extends StatefulWidget {
  const GameLayout({super.key});

  @override
  State<GameLayout> createState() => _GameLayoutState();
}

class _GameLayoutState extends State<GameLayout> {
  bool consoleMode = false;
  SeaBoard seaBoard = SeaBoard(400, UserDetails.instance.board);
  List<int> selected = [];
  ConsoleBoard consoleBoard = ConsoleBoard(400);
  String message = "";
  bool startingScreen = true;
  bool playerTurn = false;

  void changeState(Function callback) {
    setState(() {
      callback();
    });
  }

  void shoot(int x, int y) {
    setState(() {
      consoleBoard.shooting = true;
      consoleBoard.disabled = true;
      consoleBoard.update();
    });

    UserDetails.instance.game!.shoot(x, y);
  }

  void showStartingScreen() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {
          return StartingScreen();
        });
  }

  void hideStartingScreen() {
    if (startingScreen) {
      Navigator.of(context).pop();
      startingScreen = false;
    }
  }

  void showEndingScreen(String title, String message,SeaBoard enemyBoard) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return EndingScreen(
            title: title,
            message: message,
            returnToRoom: returnToLobby, enemyBoard: enemyBoard,
          );
        });
  }

  void startPlayerTurn() {
    setState(() {
      consoleBoard.disabled = false;
      playerTurn = true;
      consoleMode = true;
      message = "pick field";
      seaBoard.update();
    });
    hideStartingScreen();
  }

  void startEnemyTurn() {
    setState(() {
      message = "enemy picking field";
    });
    hideStartingScreen();
  }

  void playerHit(int x, int y) {
    setState(() {
      message = "enemy ship got hit";
      consoleBoard.shooting = false;
      consoleBoard.selected.clear();

      consoleBoard.board.setField(x, y, 1);
      consoleBoard.widget =
          BoardWidget(size: 400, getFields: consoleBoard.getFields);
    });
  }

  void enemyHit(int x, int y) {
    setState(() {
      message = "your ship got hit";
      seaBoard.board.setField(x, y, 2);
      seaBoard.update();
    });
  }

  void playerMiss(Pos? pos) {
    setState(() {
      consoleBoard.selected.clear();
      consoleBoard.shooting = false;
    });
    if (pos == null) {
      setState(() {
        message = "you didnt shoot";
      });
    } else {
      setState(() {
        message = "you missed";
      });
      consoleBoard.board.setField(pos.x, pos.y, 3);
      consoleBoard.update();
    }
  }

  void enemyMiss(Pos? pos) {
    if (pos == null) {
      setState(() {
        message = "enemy didnt shoot";
      });
    } else {
      setState(() {
        message = "enemy missed";
      });
      seaBoard.board.setField(pos.x, pos.y, 4);
      seaBoard.update();
    }
  }

  void playerSunken(int x, int y) {
    setState(() {
      consoleBoard.selected.clear();
      consoleBoard.shooting = false;
      message = "enemy ship got sunken";
    });
    consoleBoard.board.setField(x, y, 2);
    print("player sunken");
    consoleBoard.update();
  }

  void enemySunken(int x, int y) {
    setState(() {
      message = "your ship got sunken";
    });
    seaBoard.board.setField(x, y, 3);
    print("enemy sunken");
    seaBoard.update();
  }

  void enemyAlreadyHit(int x, int y) {
    setState(() {
      message = "already hit";
    });
  }

  void playerAlreadyHit(int x, int y) {
    setState(() {
      consoleBoard.selected.clear();
      consoleBoard.shooting = false;
      consoleBoard.update();
      message = "already hit";
    });
  }

  void playerShooting() {
    setState(() {
      consoleBoard.shooting = true;
      message = "shooting";
    });
    print("player shooting");
  }

  void enemyShooting() {
    setState(() {
      message = "enemy shooting";
    });
    print("enemt shooting");
  }

  void enemyForfeit(List<List<int>>fields) {
    Board board=Board();
    board.fields=fields;
    showEndingScreen("you won", "enemy forfeited",SeaBoard(350, board));
  }

  void playerForfeit(List<List<int>>fields) {
    Board board=Board();
    board.fields=fields;
    showEndingScreen("you lost", "you forfeited",SeaBoard(350, board));
  }

  void onReturnToLobby() {
    Navigator.pop(context);
  }

  void onPlayerLeft(List<List<int>>fields) {
    hideStartingScreen();
    Board board=Board();
    board.fields=fields;
    showEndingScreen("you won", "enemy left",SeaBoard(350, board));
  }

  void returnToLobby() {
    UserDetails.instance.game!.returnToRoom(context);
  }

  void handleForfeitClick() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Modal(
              child: Container(
            child: Column(
              children: [
                Label("are you sure?", fontSize: 40),
                SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Button(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      message: "no",
                      fontSize: 30,
                      backGroundColor: Color.fromRGBO(0, 0, 0, 0),
                      border: BorderSide(),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          UserDetails.instance.game!.forfeit();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: Label(
                          "yes",
                          fontSize: 30,
                          color: Colors.black,
                        )),
                  ],
                )
              ],
            ),
          ));
        });
  }

  @override
  void initState() {
    super.initState();
    consoleBoard.setChangeState(changeState);
    consoleBoard.setSelected(selected);
    UserDetails.instance.loadGame(GameFunctions(
      startPlayerTurn: startPlayerTurn,
      startEnemyTurn: startEnemyTurn,
      enemyHit: enemyHit,
      playerHit: playerHit,
      playerMiss: playerMiss,
      enemyMiss: enemyMiss,
      playerSunken: playerSunken,
      enemySunken: enemySunken,
      enemyAlreadyHit: enemyAlreadyHit,
      playerAlreadyHit: playerAlreadyHit,
      playerShooting: playerShooting,
      enemyShooting: enemyShooting,
      enemyForfeit: enemyForfeit,
      playerForfeit: playerForfeit,
      onPlayerLeft: onPlayerLeft,
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showStartingScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          width: double.infinity,
          color: Color.fromRGBO(30, 109, 226, 1),
          child: Column(
            children: [
              GameInfo(
                message: message,
              ),
              SizedBox(
                height: 60,
              ),
              Label("your ships",
                  fontSize: 50, color: Color.fromRGBO(5, 50, 128, 1)),
              SizedBox(
                height: 20,
              ),
              seaBoard.widget,
            ],
          ),
        ),
        Positioned(
          bottom: consoleMode ? 0 : -500,
          left: MediaQuery.of(context).size.width / 2 - 210,
          child: ConsolePanel2(
            setMode: (mode) {
              setState(() {
                this.consoleMode = mode;
              });
            },
            board: consoleBoard,
            mode: false,
            handleShoot: shoot,
            playerTurn: playerTurn,
            setPlayerTurn: (turn) {
              playerTurn = turn;
            },
            handleForfeit: handleForfeitClick,
          ),
        )
      ]),
    );
  }
}
