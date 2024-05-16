import 'package:flutter/src/widgets/framework.dart';
import 'package:warships_mobile/game/Game.dart';
import 'package:warships_mobile/game/OnlineGame.dart';
import 'package:warships_mobile/newBoards/Board.dart';
import 'package:warships_mobile/newBoards/CreatorBoard.dart';
import 'package:flutter/cupertino.dart';
import 'package:warships_mobile/utils/Online.dart';


class UserDetails{
  UserDetails._privateConstructor();
  static final UserDetails _instance = UserDetails._privateConstructor();
  static UserDetails get instance => _instance;
  late Game game=OnlineGame();
  Board board=Board();
  bool online=false;
  void submitShips(Board board, BuildContext context) {
    print("submitting");
    UserDetails.instance.board=board;
    if(online){
      print("online");
      Online.instance.submitShips(board.fields);
    }else{
      print("not online");
      Navigator.pop(context);
      Navigator.pushNamed(context, "/game");
    }

  }
}