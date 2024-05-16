import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:warships_mobile/components/Label.dart';

class GameInfo extends StatelessWidget {
  const GameInfo({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 30,height: 50,color: Color.fromRGBO(66, 0, 0, 1),),
          SizedBox(width: 200,height: 50,),
          Container(width: 30,height: 50,color:Color.fromRGBO(66, 0, 0, 1)),
        ],
      ),
      Container(
        width: 400,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(66, 0, 0, 1), width: 15),
          color: const Color.fromRGBO(1, 9, 3, 1),
        ),
        child: Label(
          message,
          fontSize: 30,
        ),
      ),
    ]);
  }
}
