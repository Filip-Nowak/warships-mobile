import 'package:flutter/src/widgets/framework.dart';
import 'package:warships_mobile/utils/Handler.dart';
import 'package:warships_mobile/utils/Online.dart';

import '../components/Label.dart';

class IsOwner extends Handler{
  IsOwner(super.nextHandler);


  @override
  Widget? handle() {
    if(Online.instance.userId==Online.instance.room.ownerId){
      return handleNext();
    }
    return Label(
      "room owner can start",
      fontSize: 30,
    );
  }

}