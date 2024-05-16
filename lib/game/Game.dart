import 'package:flutter/cupertino.dart';
import 'package:warships_mobile/game/GameView.dart';

abstract class Game{
  late GameView view;

  void shoot(int x, int y);
}