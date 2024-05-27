import 'package:flutter/cupertino.dart';

class Multiplier{
  static double getMultiplier(BuildContext context){
    if(MediaQuery.of(context).size.height<800){
      return MediaQuery.of(context).size.height/800;
    }
    return 1;
  }
}