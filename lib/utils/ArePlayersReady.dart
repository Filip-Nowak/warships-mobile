import 'package:flutter/src/widgets/framework.dart';
import 'package:warships_mobile/components/Label.dart';
import 'package:warships_mobile/utils/Handler.dart';
import 'package:warships_mobile/utils/Online.dart';

class ArePlayersReady extends Handler{
  ArePlayersReady(super.nextHandler);

  @override
  Widget? handle() {
    if(Online.instance.room.users.length==2){
      if(Online.instance.room.users[0].ready && Online.instance.room.users[1].ready){
        return handleNext();
      }
    }
    return Label("players are not ready", fontSize: 30);
  }

}