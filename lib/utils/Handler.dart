import 'package:flutter/cupertino.dart';

import '../components/Button.dart';

abstract class Handler{
  Handler? nextHandler;
  Handler(this.nextHandler);
  Widget? handle();
  Widget? handleNext(){
    if(nextHandler!=null){
      return nextHandler!.handle();
    }
    return null;
  }
}