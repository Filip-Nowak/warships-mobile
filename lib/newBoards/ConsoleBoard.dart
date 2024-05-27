import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:warships_mobile/newBoards/BoardManager.dart';
import 'package:warships_mobile/newBoards/BoardWidget.dart';
import 'package:warships_mobile/newBoards/Field.dart';

class ConsoleBoard extends BoardManager{
  ConsoleBoard(super.size){
    disabled=true;
  }
  List<int> selected=[];
  bool shooting=false;
  void setSelected(v){
    selected=v;
  }
  @override
  List<Field> getFields() {
    print("generated fields");
    List<Field> fields = [];
    for (int y = 0; y < 10; y++) {
      for (int x = 0; x < 10; x++) {
        Color color;
        int? value = board.getField(x, y);
        if (value == 0) {
          color = const Color.fromRGBO(13, 37, 2, 1);
        } else if (value == 1) {
          color = const Color.fromRGBO(3, 123, 8, 1);
        } else if (value == 2) {
          color = const Color.fromRGBO(66, 0, 0, 1);
        } else {
          color = const Color.fromRGBO(53, 52, 52, 1);
        }
        if(selected.isNotEmpty){
          Border border;
          if(!shooting){
            if(x==selected[0]&&y==selected[1]){
              border=Border.all(width: 5,color: Colors.green);
            }else if(x==selected[0]){
              border=Border.symmetric(vertical: BorderSide(width: 5,color: Colors.green[900]!), horizontal: BorderSide(width: 5,color: Colors.black));
            }else if(y==selected[1]){
              border=Border.symmetric(horizontal: BorderSide(width: 5,color: Colors.green[900]!),vertical: BorderSide(width: 5,color: Colors.black));
            }else{
              border=Border.all(width: 5,color: Colors.black);
            }
            fields.add(Field(backgroundColor: color, x: x, y: y, disabled: false, onClick: onClick,border: border, width: size/10, height: size/10,));
          }else{
            bool blink=false;
            if(x==selected[0]&&y==selected[1]){
              border=Border.all(width: 5,color: Colors.green);
              blink=true;
            }else{
              border=Border.all(width: 5,color: Colors.black);
            }
            fields.add(Field(backgroundColor: color, x: x, y: y, disabled: false, onClick: onClick,border: border,blink: blink,  width: size/10, height: size/10,));

          }
          continue;

        }
        fields.add(Field(
          backgroundColor: color,
          x: x,
          y: y,
          disabled: false,
          onClick: onClick,
          border: Border.all(width: 5,color: Colors.black), width: size/10, height: size/10,
        ));
      }
    }
    return fields;
  }
  void onClick(int x,int y){
    print(disabled);
    if(!disabled){
      selected.clear();
      selected.add(x);
      selected.add(y);
      changeState((){
        widget=BoardWidget(size: size, getFields: getFields);
      });
    }else{
      print(disabled);
    }

  }


}