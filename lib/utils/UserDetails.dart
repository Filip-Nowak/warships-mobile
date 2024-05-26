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
  bool submitted=false;
  late Game? game;
  Board board=Board();
  bool online=false;
  void submitShips(Board board, BuildContext context) {
    submitted=true;
    UserDetails.instance.board=board;
    if(online){
      Online.instance.submitShips(board.fields);
    }else{
      Navigator.pop(context);
      Navigator.pushNamed(context, "/game");
    }

  }
  void loadGame(GameFunctions gameFunctions){
    UserDetails.instance.submitted=false;
    if(online){
      game=OnlineGame(gameFunctions);
    }else{
      game=BotGame(gameFunctions,board);
    }
  }

  late void Function() back;
}