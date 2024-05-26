import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warships_mobile/components/Button.dart';
import 'package:warships_mobile/components/Label.dart';
import 'package:warships_mobile/components/Modal.dart';
import 'package:warships_mobile/components/TextInputField.dart';
import 'package:warships_mobile/models/Room.dart';
import 'package:warships_mobile/utils/Online.dart';

import '../utils/UserDetails.dart';

class JoinRoomLayout extends StatefulWidget {
  const JoinRoomLayout({super.key});

  @override
  State<JoinRoomLayout> createState() => _JoinRoomLayoutState();
}

class _JoinRoomLayoutState extends State<JoinRoomLayout> {
  void onJoin(String message) {
    setState(() {
      _isLoading=false;
    });
    Room room = Room.fromJson(jsonDecode(message));
    Online.instance.room = room;
    Navigator.pushNamed(context, "/room");
  }

  void onError(String message) {
    setState(() {
      _isLoading=false;
    });
    showDialog(context: context, builder: (BuildContext context){
      return Modal(child: Container(
        child: Column(
          children: [
            Label("room not found", fontSize: 50),
            Button(onPressed: (){Navigator.pop(context);}, message: "close")
          ],
        ),
      ));
    });
  }

  void joinRoom(String code) {
    setState(() {
      _isLoading=true;
    });
    Online.instance.joinRoom(code);
  }

  void createRoom() {
    setState(() {
      _isLoading=true;
    });
    Online.instance.createRoom();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Online.instance.addRoomMessageHandler("JOINED_ROOM", onJoin);
    Online.instance.addRoomMessageHandler("ERROR", onError);
    Online.instance.setJoinRoom(onJoin);
  }
  void backToHome(){
    Online.instance.deleteSession();
    Online.reset();
  }
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (xd){
        if(xd){
          return;
        }
        backToHome();
        Navigator.pop(context);
      },
      child: Stack(children: [
        Scaffold(
            body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
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
                    height: 75,
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            backToHome();
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Color.fromRGBO(143, 255, 0, 1.0),
                            size: 50,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 75,
                  ),
                  Container(
                    height: 250,
                    width: 400,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(15, 39, 3, 1),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Label("enter code", fontSize: 50),
                        SizedBox(height: 40),
                        TextInputField(
                          onClick: joinRoom,
                          fontSize: 40,
                        )
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
        )),
        if (_isLoading)
          AbsorbPointer(
            child: Stack(
              children: [
                ModalBarrier(dismissible: false, color: Colors.black.withOpacity(0.5)),
                Center(
                  child: CircularProgressIndicator(color: Color.fromRGBO(143, 255, 0, 1.0),),
                ),
              ],
            ),
          ),
      ]),
    );
  }
}
