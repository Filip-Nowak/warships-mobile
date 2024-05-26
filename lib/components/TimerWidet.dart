import 'package:flutter/cupertino.dart';

import 'Label.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key, required this.time, required this.size, this.disabled=false});
  final int time;
  final int size;
  final bool disabled;
  @override
  Widget build(BuildContext context) {
    print("timer render $disabled");
    String message="${(time/60).floor()} : ";
    if(time%60<10){
      message+="0";
    }
    message+=(time%60).toString();
    return Container(
      child: Label(message,fontSize: size,color: disabled?Color.fromRGBO(143, 255, 0, 0.5):Color.fromRGBO(143, 255, 0, 1),),
    );
  }
}
