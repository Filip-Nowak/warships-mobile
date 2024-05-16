import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warships_mobile/components/Button.dart';
import 'package:warships_mobile/components/Label.dart';
import 'package:warships_mobile/components/TextInput.dart';
import 'package:warships_mobile/models/Room.dart';
import 'package:warships_mobile/utils/Online.dart';

class JoinRoomLayout extends StatefulWidget {
  const JoinRoomLayout({super.key});

  @override
  State<JoinRoomLayout> createState() => _JoinRoomLayoutState();
}

class _JoinRoomLayoutState extends State<JoinRoomLayout> {
  void onJoin(String message) {
    Room room=Room.fromJson(jsonDecode(message));
    Online.instance.room=room;
    Navigator.pushNamed(context, "/room");
  }

  void onError(String message) {
    print("error at join room");
    print(message);
  }

  void joinRoom(String code){
    Online.instance.joinRoom(code);
  }
  void createRoom(){
    Online.instance.createRoom();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Online.instance.addRoomMessageHandler("JOINED_ROOM", onJoin);
    Online.instance.addRoomMessageHandler("ERROR", onError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if(!currentFocus.hasPrimaryFocus){
              currentFocus.unfocus();
            }
          },
          child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Color.fromRGBO(30, 0, 116, 1),
                child: SingleChildScrollView(
                  child: Column(
                            children: [
                              SizedBox(
                                height: 200,
                              ),
                              Container(
                                height: 250,
                                width: 400,
                                decoration: BoxDecoration(
                    color: Color.fromRGBO(15, 39, 3, 1),
                  borderRadius: BorderRadius.all(Radius.circular(30))
                                ),
                                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Label("enter code", fontSize: 50),
                    SizedBox(height: 40),
                    TextInput(onClick: joinRoom,fontSize: 40,)
                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Label("or", fontSize: 80),
                              SizedBox(
                                height: 40,
                              ),
                              Button(
                                onPressed: createRoom,
                                message: "create room",
                                fontSize: 50,
                              )
                            ],
                  ),
                ),
              ),
        ));
  }
}
