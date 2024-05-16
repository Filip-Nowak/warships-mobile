import 'package:flutter/cupertino.dart';
import 'package:warships_mobile/newBoards/Board.dart';
import 'package:warships_mobile/newBoards/BoardWidget.dart';
import 'package:warships_mobile/newBoards/SeaBoard.dart';
import 'package:warships_mobile/utils/UserDetails.dart';

import '../components/GameInfo.dart';
import '../components/Label.dart';
import 'BoardController.dart';

class PlayerBoard extends StatefulWidget {
  const PlayerBoard({super.key, required this.controller});
  final BoardController controller;
  @override
  State<PlayerBoard> createState() => _PlayerBoardState();
}

class _PlayerBoardState extends State<PlayerBoard> {
  SeaBoard board=SeaBoard(400, UserDetails.instance.board);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.setBoard=(Board board){
      setState(() {
        print("setting board");
        this.board.board=board;
        this.board.widget=BoardWidget(size: 400, getFields: this.board.getFields);
      });
    };
    widget.controller.getBoardManager=(){
      return board;
    };
  }
  @override
  Widget build(BuildContext context) {
    print("render2");
    return Container(
      width: double.infinity,
      color: Color.fromRGBO(30, 109, 226, 1),
      child: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Label("your ships",
              fontSize: 50, color: Color.fromRGBO(5, 50, 128, 1)),
          SizedBox(
            height: 20,
          ),
          board.widget,
        ],
      ),
    );
  }
}
