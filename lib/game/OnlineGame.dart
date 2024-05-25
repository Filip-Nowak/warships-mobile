import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:warships_mobile/game/Game.dart';
import 'package:warships_mobile/game/GameView.dart';
import 'package:warships_mobile/game/GameViewController.dart';
import 'package:warships_mobile/models/GameLog.dart';
import 'package:warships_mobile/models/Pos.dart';
import 'package:warships_mobile/models/RoomMessage.dart';
import 'package:warships_mobile/models/User.dart';
import 'package:warships_mobile/newBoards/Board.dart';
import 'package:warships_mobile/utils/Online.dart';
import 'package:warships_mobile/utils/UserDetails.dart';

import '../models/EndGameUser.dart';
import '../models/Room.dart';

class OnlineGame extends Game{
  // late GameView _view;

  // @override
  // GameView get view => _view;




  OnlineGame(super.gameFunctions){
    Online.instance.addGameLogHandler("STARTED_TURN", onStartedTurn);
    Online.instance.addGameLogHandler("HIT", onHit);
    Online.instance.addGameLogHandler("MISS", onMiss);
    Online.instance.addGameLogHandler("SUNKEN", onSunken);
    Online.instance.addGameLogHandler("ALREADY_HIT", onAlreadyHit);
    Online.instance.addGameLogHandler("SHOOTING", onShooting);
    Online.instance.addGameLogHandler("WIN", onWin);
    Online.instance.addRoomMessageHandler("PLAYER_LEFT", onPlayerLeft);
    Online.instance.addRoomMessageHandler("FORFEIT", onForfeit);

  }

  void onStartedTurn(GameLog log){
    if(log.senderId==Online.instance.userId){
      gameFunctions.startPlayerTurn();
    }else{
      gameFunctions.startEnemyTurn();
    }
  }
  void onHit(GameLog log){
    if(log.senderId==Online.instance.userId){
      gameFunctions.playerHit(log.pos!.x,log.pos!.y);
    }else{
      gameFunctions.enemyHit(log.pos!.x,log.pos!.y);
    }
  }
  void onMiss(GameLog log){
    if(log.senderId==Online.instance.userId){
      gameFunctions.playerMiss(log.pos);
    }else{
      gameFunctions.enemyMiss(log.pos);
    }
  }
  void onSunken(GameLog log){
    if(log.senderId==Online.instance.userId){
      gameFunctions.playerSunken(log.pos!.x,log.pos!.y);
    }else{
      gameFunctions.enemySunken(log.pos!.x,log.pos!.y);
    }
  }

  void onAlreadyHit(GameLog log){
    if(log.senderId==Online.instance.userId){
      gameFunctions.playerAlreadyHit(log.pos!.x,log.pos!.y);
    }else{
      gameFunctions.enemyAlreadyHit(log.pos!.x,log.pos!.y);
    }
  }
  void onShooting(GameLog log){
    if(log.senderId==Online.instance.userId){
      gameFunctions.playerShooting();
    }else{
      gameFunctions.enemyShooting();
    }
  }
  void onWin(GameLog log){
    Online.instance.addGameLogHandler("STARTED_TURN", (GameLog log){});
    Online.instance.addGameLogHandler("HIT", (GameLog log){});
    Online.instance.addGameLogHandler("MISS", (GameLog log){});
    Online.instance.addGameLogHandler("SUNKEN", (GameLog log){});
    Online.instance.addGameLogHandler("ALREADY_HIT", (GameLog log){});
    Online.instance.addGameLogHandler("SHOOTING", (GameLog log){});
    Online.instance.addGameLogHandler("WIN", (GameLog log){});
  }
  void onPlayerLeft(String message){
    print("left from game");
    Online.instance.addGameLogHandler("STARTED_TURN", (GameLog log){});
    Online.instance.addGameLogHandler("HIT", (GameLog log){});
    Online.instance.addGameLogHandler("MISS", (GameLog log){});
    Online.instance.addGameLogHandler("SUNKEN", (GameLog log){});
    Online.instance.addGameLogHandler("ALREADY_HIT", (GameLog log){});
    Online.instance.addGameLogHandler("SHOOTING", (GameLog log){});
    Online.instance.addGameLogHandler("WIN", (GameLog log){});
    if(json.decode(message) is int){
      Room room=Online.instance.room;
      for(int i=0;i<room.users.length;i++){
        if(room.users[i].id==json.decode(message).toString()){
          room.users.removeAt(i);
          room.ownerId=Online.instance.userId;
        }
      }
    }else{
      EndGameUser user = EndGameUser.fromJson(jsonDecode(message));
      Room room=Online.instance.room;
      for(int i=0;i<room.users.length;i++){
        if(room.users[i].id==user.id){
          room.users.removeAt(i);
          room.ownerId=Online.instance.userId;
        }
      }
      gameFunctions.onPlayerLeft(user.fields);
    }

  }
  void onForfeit(String msg){
    Online.instance.addGameLogHandler("STARTED_TURN", (GameLog log){});
    Online.instance.addGameLogHandler("HIT", (GameLog log){});
    Online.instance.addGameLogHandler("MISS", (GameLog log){});
    Online.instance.addGameLogHandler("SUNKEN", (GameLog log){});
    Online.instance.addGameLogHandler("ALREADY_HIT", (GameLog log){});
    Online.instance.addGameLogHandler("SHOOTING", (GameLog log){});
    Online.instance.addGameLogHandler("WIN", (GameLog log){});
    EndGameUser user = EndGameUser.fromJson(jsonDecode(msg));
    if(user.id==Online.instance.userId){
      gameFunctions.playerForfeit(user.fields);
    }else{
      gameFunctions.enemyForfeit(user.fields);
    }
  }


  @override
  void shoot(Pos? pos) {
    print("shooting in online game");
    Online.instance.shoot(pos);
  }

  @override
  void returnToRoom(BuildContext context) {
    Online.instance.updateRoom();
    Online.instance.creator=false;
    UserDetails.instance.game=null;
    UserDetails.instance.board=Board();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void forfeit() {
    Online.instance.forfeit();
  }



}