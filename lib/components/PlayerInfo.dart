import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Label.dart';

class PlayerInfo extends StatelessWidget {
  const PlayerInfo({super.key, required this.nickname,this.ready});

  final String nickname;
  final bool? ready;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      child: Column(
        children: [
          Container(
              height: 70,
              child: Center(
                  child: Label(nickname.isNotEmpty ? nickname : "waiting",
                      fontSize: nickname.length < 5
                          ? 40
                          : (190 / nickname.length.floor()).toInt(),
                  color: Color.fromRGBO(143, 255, 0, nickname.isEmpty?0.5:1),))),
          ready==null?const SizedBox():Label("ready", fontSize: 25, color: Color.fromRGBO(143, 255, 0, ready!?1:0.5))
        ],
      ),
    );
  }
}
