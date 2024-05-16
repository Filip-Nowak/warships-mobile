import 'package:warships_mobile/models/Pos.dart';
import 'package:warships_mobile/models/Pos.dart';
import 'package:warships_mobile/newBoards/Board.dart';

class GameViewController{
  void Function () showStartingScreen=(){};
  void Function () hideStartingScreen=(){};
  void Function (Board) setPlayerBoard=(Board board){};
  void Function (Board) setConsoleBoard=(Board board){};
  Board Function () getPlayerBoard=(){return Board();};
  Board Function () getConsoleBoard=(){return Board();};


  late void Function () startPlayerTurn;
  late void Function () startEnemyTurn;
  late void Function (int,int) playerHit;
  late void Function (int,int) enemyHit;
  late void Function (Pos?) playerMiss;
  late void Function (Pos?) enemyMiss;
  late void Function (int,int) playerSunken;
  late void Function (int,int) enemySunken;
  late void Function (int,int) enemyAlreadyHit;
  late void Function (int,int) playerAlreadyHit;
  late void Function () playerShooting;
  late void Function () enemyShooting;
}