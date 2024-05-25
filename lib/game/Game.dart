import 'package:flutter/cupertino.dart';
import 'package:warships_mobile/game/GameFunctions.dart';
import 'package:warships_mobile/game/GameView.dart';

import '../models/Pos.dart';

abstract class Game{
  // late GameView view;
  const Game(this.gameFunctions);
  void shoot(Pos? pos);
  final GameFunctions gameFunctions;
  void returnToRoom(BuildContext context);

  void forfeit();
}