import 'package:flutter/cupertino.dart';
import 'package:warships_mobile/game/GameFunctions.dart';
import 'package:warships_mobile/game/GameView.dart';

import '../models/Pos.dart';

abstract class Game{
  // late GameView view;
  const Game(this.gameFunctions);
  void shoot(int x, int y);
  final GameFunctions gameFunctions;
}