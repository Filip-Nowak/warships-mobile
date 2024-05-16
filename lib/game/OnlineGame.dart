import 'package:warships_mobile/game/Game.dart';
import 'package:warships_mobile/game/GameView.dart';
import 'package:warships_mobile/game/GameViewController.dart';
import 'package:warships_mobile/models/GameLog.dart';
import 'package:warships_mobile/models/Pos.dart';
import 'package:warships_mobile/utils/Online.dart';

class OnlineGame extends Game{
  late GameView _view;

  @override
  GameView get view => _view;
  late GameViewController _controller;

  GameViewController get controller => _controller;

  OnlineGame(){
    this._controller=GameViewController();
    this._view=GameView(gameViewController: _controller,);
    Online.instance.addGameLogHandler("STARTED_TURN", onStartedTurn);
    Online.instance.addGameLogHandler("HIT", onHit);
    Online.instance.addGameLogHandler("MISS", onMiss);
    Online.instance.addGameLogHandler("SUNKEN", onSunken);
    Online.instance.addGameLogHandler("ALREADY_HIT", onAlreadyHit);
    Online.instance.addGameLogHandler("SHOOTING", onShooting);
    Online.instance.addGameLogHandler("WIN", onWin);
    Online.instance.addGameLogHandler("PLAYER_LEFT", onPlayerLeft);
    Online.instance.addGameLogHandler("FORFEIT", onForfeit);
  }

  void onStartedTurn(GameLog log){
    if(log.senderId==Online.instance.userId){
      controller.startPlayerTurn();
    }else{
      controller.startEnemyTurn();
    }
  }
  void onHit(GameLog log){
    if(log.senderId==Online.instance.userId){
      controller.playerHit(log.pos!.x,log.pos!.y);
    }else{
      controller.enemyHit(log.pos!.x,log.pos!.y);
    }
  }
  void onMiss(GameLog log){
    if(log.senderId==Online.instance.userId){
      controller.playerMiss(log.pos);
    }else{
      controller.enemyMiss(log.pos);
    }
  }
  void onSunken(GameLog log){
    if(log.senderId==Online.instance.userId){
      controller.playerSunken(log.pos!.x,log.pos!.y);
    }else{
      controller.enemySunken(log.pos!.x,log.pos!.y);
    }
  }

  void onAlreadyHit(GameLog log){
    if(log.senderId==Online.instance.userId){
      controller.playerAlreadyHit(log.pos!.x,log.pos!.y);
    }else{
      controller.enemyAlreadyHit(log.pos!.x,log.pos!.y);
    }
  }
  void onShooting(GameLog log){
    if(log.senderId==Online.instance.userId){
      controller.playerShooting();
    }else{
      controller.enemyShooting();
    }
  }
  void onWin(GameLog log){

  }
  void onPlayerLeft(GameLog log){

  }
  void onForfeit(GameLog log){

  }

  @override
  void shoot(int x, int y) {
    print("shooting in online game");
    Online.instance.shoot(Pos(x: x, y: y));
  }



}