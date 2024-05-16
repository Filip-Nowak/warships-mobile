import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:warships_mobile/components/Button.dart';
import 'package:warships_mobile/components/Label.dart';
import 'package:warships_mobile/components/PlayerInfo.dart';
import 'package:warships_mobile/models/Room.dart';
import 'package:warships_mobile/utils/ArePlayersReady.dart';
import 'package:warships_mobile/utils/Handler.dart';
import 'package:warships_mobile/utils/IsFull.dart';
import 'package:warships_mobile/utils/isOwner.dart';

import '../models/User.dart';
import '../utils/Online.dart';

class RoomLayout extends StatefulWidget {
  const RoomLayout({super.key});

  @override
  State<RoomLayout> createState() => _RoomLayoutState();
}

class _RoomLayoutState extends State<RoomLayout> {
  List<User> users = [];
  bool playerReady = false;

  @override
  void initState() {
    // TODO: implement initState
    users=Online.instance.room.users;
    Online.instance.addRoomMessageHandler("JOINED_ROOM", onJoinRoom);
    Online.instance.addRoomMessageHandler("READY", onReady);
    Online.instance.addRoomMessageHandler("NOT_READY", onNotReady);
    Online.instance.addRoomMessageHandler("START", onStartCreator);
  }


  void onJoinRoom(String string){
    Online.instance.room=Room.fromJson(jsonDecode(string));
    setState(() {
      users=Online.instance.room.users;
    });
  }
  void onReady(String msg){
    User? user=Online.instance.room.getUser(msg);
    if(user!=null){
      user.ready=true;
    }
    setState(() {
      users=Online.instance.room.users;
    });
  }
  void onNotReady(String msg){
    User? user=Online.instance.room.getUser(msg);
    if(user!=null){
      user.ready=false;
    }
    setState(() {
      users=Online.instance.room.users;
    });
  }
  void onStartCreator(String message){
    for(User user in Online.instance.room.users){
      user.ready=false;
    }
    Online.instance.creator=true;
    Navigator.pushNamed(context, "/creator");

  }




  void handleReadyButton(){
    setState(() {
      Online.instance.setReady(!playerReady);
      playerReady=!playerReady;
    });
  }


  @override
  Widget build(BuildContext context) {
    Handler handler = IsFull(ArePlayersReady(IsOwner(null)));
    Widget? result = handler.handle();
    result ??= Container(
        width: 400,
    child: Button(onPressed: () {}, message: "start",fontSize: 50,));
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(0, 24, 1, 1),
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Label("room code", fontSize: 50),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.black,
              width: 300,
              padding: EdgeInsets.symmetric(horizontal: 40),
              // child: Label(Online.instance.getRoom()!.id,fontSize: 80,),
              child: Label(
                Online.instance.room.id,
                fontSize: 80,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Label("players", fontSize: 50),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PlayerInfo(
                  nickname: users[0].nickname,
                  ready: users[0].ready,
                ),
                users.length == 2
                    ? PlayerInfo(
                        nickname: users[1].nickname,
                        ready: users[1].ready,
                      )
                    : PlayerInfo(nickname: ""),
              ],
            ),
            SizedBox(height: 150),
            Container(
                width: 400,
                child: playerReady
                    ? Button(
                        onPressed: handleReadyButton,
                        message: "ready",
                        fontSize: 50,
                        backGroundColor: Color.fromRGBO(0, 0, 0, 0),
                        border: BorderSide(
                            color: Color.fromRGBO(143, 255, 0, 1), width: 5),
                      )
                    : Button(
                        onPressed: handleReadyButton,
                        message: "ready",
                        fontSize: 50,
                      )),
            SizedBox(height: 20,),
            result
          ],
        ),
      ),
    );
  }
}
