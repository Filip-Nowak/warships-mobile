import 'dart:async';

class StopWatch{
  StopWatch({required this.onTimeChange,required this.onTimeEnd});
  int time=0;
  Function(int) onTimeChange;
  void Function() onTimeEnd;
  late Timer timer;
  void start(int time){
    if(this.time==0){
      time=time;
      timer=Timer.periodic(Duration(seconds: 1), (Timer t){
        time--;
        onTimeChange(time);
        if(time==0){
          timer.cancel();
          onTimeEnd();
        }
      });
    }

  }
}