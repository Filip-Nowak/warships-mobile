import 'package:flutter/material.dart';
import 'package:warships_mobile/layouts/GameLayout.dart';
import 'package:warships_mobile/layouts/JoinRoomLayout.dart';
import 'package:warships_mobile/layouts/RoomLayout.dart';
import 'package:warships_mobile/utils/Bot.dart';
import 'package:warships_mobile/utils/UserDetails.dart';

import 'layouts/CreatorLayout.dart';
import 'layouts/HomeLayout.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/home",
    routes: {
      "/home":(context)=> const HomeLayout(),
      "/creator":(context)=>const CreatorLayout(),
      "/game":((context)=>  const GameLayout()),
      "/createRoom":(context)=>const JoinRoomLayout(),
      "/room":(context)=>const RoomLayout()
    },
  ));
}

