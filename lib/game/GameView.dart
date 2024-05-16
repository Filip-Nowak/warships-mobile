import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:warships_mobile/components/Button.dart';
import 'package:warships_mobile/components/Modal.dart';
import 'package:warships_mobile/game/BoardController.dart';
import 'package:warships_mobile/game/ConsolePanel.dart';
import 'package:warships_mobile/game/PlayerBoard.dart';
import 'package:warships_mobile/game/StartingScreen.dart';
import 'package:warships_mobile/newBoards/Board.dart';
import 'package:warships_mobile/newBoards/BoardWidget.dart';
import 'package:warships_mobile/newBoards/ConsoleBoard.dart';
import 'package:warships_mobile/newBoards/SeaBoard.dart';
import 'package:warships_mobile/utils/UserDetails.dart';

import '../components/GameInfo.dart';
import '../components/Label.dart';
import '../models/Pos.dart';
import 'GameViewController.dart';

class GameView extends StatefulWidget {
  const GameView({super.key, required this.gameViewController});

  final GameViewController gameViewController;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final BoardController playerBoardController =
      BoardController((Board board) {});
  final BoardController consoleBoardController =
      BoardController((Board board) {});

  late PlayerBoard playerBoard;

  late ConsolePanel consolePanel;

  bool startingScreen = true;

  bool playerTurn = false;

  String message = "";

  void startPlayerTurn() {
    setState(() {
      message = "pick field";
    });
    hideStartingScreen();
    consolePanel.controller.setPlayerTurn(true);
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
    });
    Board board = consolePanel.controller.getBoardManager().board;
    board.setField(x, y, 1);
    consolePanel.controller.setBoard(board);
  }

  void enemyHit(int x, int y) {
    setState(() {
      message = "your ship got hit";
    });
    Board board = playerBoard.controller.getBoardManager().board;
    board.setField(x, y, 2);
    playerBoard.controller.setBoard(board);
  }

  void playerMiss(Pos? pos) {
    if (pos == null) {
      setState(() {
        message = "you didnt shoot";
      });
    } else {
      setState(() {
        message = "you missed";
      });
      Board board = consolePanel.controller.getBoardManager().board;
      board.setField(pos.x, pos.y, 3);
      consolePanel.controller.setBoard(board);
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
      Board board = playerBoard.controller.getBoardManager().board;
      board.setField(pos.x, pos.y, 4);
      playerBoard.controller.setBoard(board);
    }
  }

  void playerSunken(int x, int y) {
    setState(() {
      message = "enemy ship got sunken";
    });
    Board board = consolePanel.controller.getBoardManager().board;
    // for(Pos pos in ship){
    //   board.setField(pos.x, pos.y, 2);
    // }
    board.setField(x, y, 2);
    print("player sunken");
    consolePanel.controller.setBoard(board);
  }

  void enemySunken(int x, int y) {
    setState(() {
      message = "your ship got sunken";
    });
    Board board = playerBoard.controller.getBoardManager().board;
    // for(Pos pos in ship){
    //   board.setField(pos.x, pos.y, 2);
    // }
    board.setField(x, y, 3);
    print("enemy sunken");
    playerBoard.controller.setBoard(board);
  }

  void enemyAlreadyHit(int x, int y) {
    setState(() {
      message = "already hit";
    });
  }

  void playerAlreadyHit(int x, int y) {
    setState(() {
      message = "already hit";
    });
  }

  void playerShooting() {
    setState(() {
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

  void shoot(int x, int y) {
    consolePanel.controller.setPlayerTurn(false);
    setState(() {
      consolePanel.controller.getBoardManager().disabled=true;
      // consolePanel.controller.getBoardManager() .shooting=true;
      consolePanel.controller.getBoardManager().widget = BoardWidget(
          size: 400,
          getFields: consolePanel.controller.getBoardManager().getFields);
    });
    UserDetails.instance.game.shoot(x, y);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playerBoard = PlayerBoard(controller: playerBoardController);
    consolePanel = ConsolePanel(
      setMode: (bool mode) {
        print("setmode");
        setState(() {
          consolePanel.controller.setMode(mode);
        });
      },
      controller: consoleBoardController,
      handleShoot: shoot,
    );
    widget.gameViewController.hideStartingScreen = hideStartingScreen;
    widget.gameViewController.setConsoleBoard = setConsoleBoard;
    widget.gameViewController.setPlayerBoard = setPlayerBoard;
    widget.gameViewController.getConsoleBoard = () {
      return consolePanel.controller.getBoardManager().board;
    };
    widget.gameViewController.getPlayerBoard = () {
      return playerBoard.controller.getBoardManager().board;
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showStartingScreen();
    });
    widget.gameViewController.startPlayerTurn = startPlayerTurn;
    widget.gameViewController.startEnemyTurn = startEnemyTurn;
    widget.gameViewController.playerHit = playerHit;
    widget.gameViewController.enemyHit = enemyHit;
    widget.gameViewController.playerSunken = playerSunken;
    widget.gameViewController.enemySunken = enemySunken;
    widget.gameViewController.playerMiss = playerMiss;
    widget.gameViewController.enemyMiss = enemyMiss;
    widget.gameViewController.enemyAlreadyHit = enemyAlreadyHit;
    widget.gameViewController.playerAlreadyHit = playerAlreadyHit;
    widget.gameViewController.enemyShooting = enemyShooting;
    widget.gameViewController.playerShooting = playerShooting;
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

  void setPlayerBoard(Board board) {
    playerBoard.controller.setBoard(board);
  }

  void setConsoleBoard(Board board) {
    consolePanel.controller.setBoard(board);
  }

  @override
  Widget build(BuildContext context) {
    print("render");
    return Container(
      color: Color.fromRGBO(30, 109, 226, 1),
      child: Stack(children: [
        Column(children: [
          GameInfo(
            message: message,
          ),
          playerBoard,
        ]),
        consolePanel
      ]),
    );
  }
}
