import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:warships_mobile/game/Game.dart';
import 'package:warships_mobile/models/Pos.dart';
import 'package:warships_mobile/newBoards/Board.dart';
import 'package:warships_mobile/utils/Bot.dart';
import 'package:warships_mobile/utils/UserDetails.dart';

class BotGame extends Game {
  BotGame(super.gameFunctions, this.playerBoard) {
    bot=Bot(handleShot);
    Timer(Duration(seconds: 5), () {
      gameFunctions.startPlayerTurn();
    });
  }

  late Bot bot;
  int botHp = 10;
  int playerHp = 10;
  Board playerBoard;

  @override
  void forfeit() {
    endGame();
    gameFunctions.playerForfeit(bot.board.fields);
  }

  @override
  void returnToRoom(BuildContext context) {
    UserDetails.instance.board=Board();
    UserDetails.instance.game=null;
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  void shoot(Pos? pos1) {
    gameFunctions.playerShooting();
    bool continueShooting=false;
    timer4 =Timer(Duration(seconds: 2), () {
      print("shooting in bot");
      Pos pos = pos1!;
      gameFunctions.playerShooting();
      Map<String, bool> result = bot.shoot(pos);
      bool hit = result["hit"]!, sunken = result["sunken"]!, alreadyHiy=result["alreadyHit"]!;
      print("hit:$hit sunken:$sunken");
      if(alreadyHiy){
        gameFunctions.playerAlreadyHit(pos.x,pos.y);
      }else if (hit) {
        continueShooting=true;
        if (sunken) {
          gameFunctions.playerSunken(pos.x, pos.y);
          botHp--;
          if (botHp == 0) {
            endGame();
            gameFunctions.playerWin(bot.board.fields);
            return;
          }
        } else {
          gameFunctions.playerHit(pos.x, pos.y);
        }
      } else {
        gameFunctions.playerMiss(pos);
      }
      timer3 = Timer(Duration(seconds: 2),(){
        if(continueShooting){
          gameFunctions.startPlayerTurn();
        }else{
          gameFunctions.startEnemyTurn();
          timer2 =Timer(Duration(seconds: 1),(){
            bot.takeShot();
          });
        }

      });
    });
  }

  void handleShot(Pos pos) {
    int field=playerBoard.getField(pos.x, pos.y)!;
    bool continueShooting=false;
    if(field==0 || field==4){
      gameFunctions.enemyMiss(pos);
    }else if(field==1){
      continueShooting=true;
      Board cloned=playerBoard.clone();
      bool sunken=true;
      cloned.fields[pos.y][pos.x]=5;
      callback(x,y){
        if(cloned.getField(x, y)==1){
          sunken=false;
        }else if(cloned.getField(x, y)==2){
          cloned.fields[y][x]=5;
          cloned.forCrossFields(x, y, callback);
        }
      }
      cloned.forCrossFields(pos.x, pos.y, callback);
      if(sunken){
        gameFunctions.enemySunken(pos.x,pos.y);
        bot.shotResult(2, pos);
        playerHp--;
        if(playerHp==0){
          endGame();
          gameFunctions.playerLost(bot.board.fields);
        }
      }else{
        gameFunctions.enemyHit(pos.x,pos.y);
        bot.shotResult(1,pos);
      }
    }else{
      gameFunctions.enemyAlreadyHit(pos.x,pos.y);
    }
    if(field!=1){
      bot.shotResult(0, pos);
    }
    timer1 = Timer(Duration(seconds: 2),(){
      if(continueShooting){
        gameFunctions.startEnemyTurn();
        timer2=Timer(Duration(seconds: 1), () {
          bot.takeShot();
        });
      }else
      {
        gameFunctions.startPlayerTurn();
      }
    });
  }
  Timer? timer1;
  Timer? timer2;
  Timer? timer3;
  Timer? timer4;
  void endGame(){
    if(timer1!=null) {
      timer1!.cancel();
    }
    if(timer2!=null) {
      timer2!.cancel();
    }if(timer3!=null) {
      timer3!.cancel();
    }if(timer4!=null) {
      timer4!.cancel();
    }

  }
}
