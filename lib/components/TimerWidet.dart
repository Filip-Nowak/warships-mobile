import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Label.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key, required this.time, required this.size, this.disabled=false, this.dangerZone=0});
  final int time;
  final int size;
  final bool disabled;
  final int dangerZone;
  @override
  Widget build(BuildContext context) {
    print("timer render $disabled");
    String message="${(time/60).floor()} : ";
    if(time%60<10){
      message+="0";
    }
    message+=(time%60).toString();
    return Container(
      child: Label(message,fontSize: size,color: disabled?Color.fromRGBO(143, 255, 0, 0.5):(time<dangerZone && time!=0)?Colors.red:Color.fromRGBO(143, 255, 0, 1),),
    );
  }
}
