import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warships_mobile/components/Button.dart';
import 'package:warships_mobile/newBoards/SeaBoard.dart';

import '../components/Label.dart';
import '../components/Modal.dart';

class EndingScreen extends StatelessWidget {
  const EndingScreen({super.key, required this.title, required this.message, required this.returnToRoom, required this.enemyBoard});
  final String title;
  final String message;
  final Function returnToRoom;
  final SeaBoard enemyBoard;
  void showEnemyShips(BuildContext context){
    showDialog(context: context, builder: (BuildContext context){
      return Modal(
        child: Column(
        children: [
          SizedBox(height: 30,),
          Label("enemy ships", fontSize: 40),
          enemyBoard.widget,
          SizedBox(height: 20,),
          Button(onPressed: (){Navigator.pop(context);}, message: "close",fontSize: 40,)
        ],
      ),
        backgroundColor: Color.fromRGBO(30, 109, 226, 1),
        height: 550,
        width: 400,
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return  PopScope(
      canPop: false,
      onPopInvoked: (xd){
        if(xd){
          return;
        }
      },
      child: Modal(child: Column(
        children: [
          Label(title, fontSize: 40),
          Label(message,fontSize: 30,),
          SizedBox(height: 50,),
          Button(onPressed: (){showEnemyShips(context);}, message: "showEnemyShip",fontSize: 25,),
          SizedBox(height: 5,),
          Button(onPressed: returnToRoom, message: "return to lobby",fontSize: 25,)
        ],
      ), height: 280,),
    );
  }
}
