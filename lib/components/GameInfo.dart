import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:warships_mobile/components/Label.dart';

import '../utils/Multiplier.dart';

class GameInfo extends StatelessWidget {
  const GameInfo({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    double multiplier=Multiplier.getMultiplier(context);
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 30,height: 50*multiplier.toDouble(),color: Color.fromRGBO(66, 0, 0, 1),),
          SizedBox(width: 200),
          Container(width: 30,height: 50*multiplier.toDouble(),color:Color.fromRGBO(66, 0, 0, 1)),
        ],
      ),
      Container(
        width: MediaQuery.of(context).size.width*0.95,
        height: 80*multiplier.toDouble(),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(66, 0, 0, 1), width: 15*multiplier.toDouble()),
          color: const Color.fromRGBO(1, 9, 3, 1),
        ),
        child: Label(
          message,
          fontSize: (30*multiplier).toInt(),
        ),
      ),
    ]);
  }
}
