import 'package:flutter/src/widgets/framework.dart';
import 'package:warships_mobile/components/Label.dart';
import 'package:warships_mobile/utils/Handler.dart';
import 'package:warships_mobile/utils/Online.dart';

class IsFull extends Handler{
  IsFull(super.nextHandler);

  @override
  Widget? handle() {
    if(Online.instance.room.users.length==2){
      return handleNext();
    }
    return Label("waiting for players", fontSize: 40);
  }

}