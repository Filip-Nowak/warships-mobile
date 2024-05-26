import '../models/Pos.dart';

class GameFunctions {
  const GameFunctions({
    required this.playerWin,
    required this.playerLost,
    required this.onPlayerLeft,
    required this.enemyForfeit,
    required this.playerForfeit,
    required this.startPlayerTurn,
    required this.startEnemyTurn,
    required this.enemyHit,
    required this.playerHit,
    required this.playerMiss,
    required this.enemyMiss,
    required this.playerSunken,
    required this.enemySunken,
    required this.enemyAlreadyHit,
    required this.playerAlreadyHit,
    required this.playerShooting,
    required this.enemyShooting,
  });

  final void Function() startPlayerTurn;
  final void Function() startEnemyTurn;
  final void Function(int, int) enemyHit;
  final void Function(int, int) playerHit;
  final void Function(Pos?) playerMiss;
  final void Function(Pos?) enemyMiss;
  final void Function(int, int) playerSunken;
  final void Function(int, int) enemySunken;
  final void Function(int, int) enemyAlreadyHit;
  final void Function(int, int) playerAlreadyHit;
  final void Function() playerShooting;
  final void Function() enemyShooting;
  final void Function(List<List<int>>) playerForfeit;
  final void Function(List<List<int>>) enemyForfeit;
  final void Function(List<List<int>>) onPlayerLeft;

  final void Function(List<List<int>> fields) playerWin;

  final void Function(List<List<int>> fields) playerLost;
}
