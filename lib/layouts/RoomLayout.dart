import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:warships_mobile/components/Button.dart';
import 'package:warships_mobile/components/Label.dart';
import 'package:warships_mobile/components/PlayerInfo.dart';
import 'package:warships_mobile/models/Room.dart';
import 'package:warships_mobile/newBoards/Board.dart';
import 'package:warships_mobile/utils/ArePlayersReady.dart';
import 'package:warships_mobile/utils/Handler.dart';
import 'package:warships_mobile/utils/IsFull.dart';
import 'package:warships_mobile/utils/UserDetails.dart';
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
    Online.instance.addRoomMessageHandler("BACK", onBack);
    Online.instance.addRoomMessageHandler("PLAYER_LEFT", onPlayerLeft);
    Online.instance.updateRoom=(){
      setState(() {
        Online.instance.addRoomMessageHandler("PLAYER_LEFT", onPlayerLeft);
        users=Online.instance.room.users;
      });
    };
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
    setState(() {
      for(User user in Online.instance.room.users){
        user.ready=false;
      }
      Online.instance.creator=true;
      playerReady=false;

    });
    UserDetails.instance.back=back;
    Navigator.pushNamed(context, "/creator");

  }
  void back(){
    Online.instance.back();
  }
  void onPlayerLeft(String msg){
    if(msg==Online.instance.userId){
      Online.instance.addRoomMessageHandler("JOINED_ROOM", (String str){});
      Online.instance.addRoomMessageHandler("READY", (String str){});
      Online.instance.addRoomMessageHandler("NOT_READY", (String str){});
      Online.instance.addRoomMessageHandler("START", (String str){});
      Online.instance.addRoomMessageHandler("PLAYER_LEFT", (String str){});
      Online.instance.deleteRoomData();
      Online.instance.changeJoinRoom();
      Navigator.pop(context);
    }else{
      setState(() {
        User? user=Online.instance.room.getUser(msg);
        if(user!=null){
          Online.instance.room.users.remove(user);
          Online.instance.room.ownerId=Online.instance.userId;
          users=Online.instance.room.users;
        }
        if(Online.instance.creator){
          Navigator.pop(context);
        }
      });
    }
  }

  void onBack(String msg){
    UserDetails.instance.board=Board();
    Online.instance.creator=false;
    Navigator.pop(context);
  }


  void handleReadyButton(){
    setState(() {
      Online.instance.setReady(!playerReady);
      playerReady=!playerReady;
    });
  }

  void handleStartButton(){
    Online.instance.startCreator();
  }

  void leaveRoom(){
    Online.instance.leave();
  }

  @override
  Widget build(BuildContext context) {
    Handler handler = IsFull(ArePlayersReady(IsOwner(null)));
    Widget? result = handler.handle();
    result ??= Container(
        width: 400,
    child: Button(onPressed: handleStartButton, message: "start",fontSize: 50,));
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(0, 24, 1, 1),
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                IconButton(onPressed: leaveRoom, icon: Icon(Icons.arrow_back,size: 50,color: Color.fromRGBO(143, 255, 0,0.5),))
              ],
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
            SizedBox(height: 100),
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
