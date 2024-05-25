import 'package:flutter/src/widgets/framework.dart';
import 'package:warships_mobile/game/Game.dart';
import 'package:warships_mobile/game/GameFunctions.dart';
import 'package:warships_mobile/game/OnlineGame.dart';
import 'package:warships_mobile/newBoards/Board.dart';
import 'package:warships_mobile/newBoards/CreatorBoard.dart';
import 'package:flutter/cupertino.dart';
import 'package:warships_mobile/utils/BotGame.dart';
import 'package:warships_mobile/utils/Online.dart';


class UserDetails{
  UserDetails._privateConstructor();
  static final UserDetails _instance = UserDetails._privateConstructor();
  static UserDetails get instance => _instance;
  late Game? game;
  Board board=Board();
  bool online=false;
  void submitShips(Board board, BuildContext context) {
    UserDetails.instance.board=board;
    if(online){
      Online.instance.submitShips(board.fields);
    }else{
      Navigator.pop(context);
      Navigator.pushNamed(context, "/game");
    }

  }
  void loadGame(GameFunctions gameFunctions){
    if(online){
      game=OnlineGame(gameFunctions);
    }else{
      game=BotGame(gameFunctions);
    }
  }

  late void Function() back;
}