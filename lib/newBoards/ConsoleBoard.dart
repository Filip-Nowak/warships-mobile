import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:warships_mobile/newBoards/BoardManager.dart';
import 'package:warships_mobile/newBoards/BoardWidget.dart';
import 'package:warships_mobile/newBoards/Field.dart';

class ConsoleBoard extends BoardManager{
  ConsoleBoard(super.size);
  List<int> selected=[];
  bool shooting=false;
  void setSelected(v){
    selected=v;
  }
  @override
  List<Field> getFields() {
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
          if(x==selected[0]&&y==selected[1]){
            border=Border.all(width: 5,color: Colors.green);
          }else if(x==selected[0]){
            border=Border.symmetric(vertical: BorderSide(width: 5,color: Colors.green[900]!), horizontal: BorderSide(width: 5,color: Colors.black));
          }else if(y==selected[1]){
            border=Border.symmetric(horizontal: BorderSide(width: 5,color: Colors.green[900]!),vertical: BorderSide(width: 5,color: Colors.black));
          }else{
            border=Border.all(width: 5,color: Colors.black);
          }
          fields.add(Field(backgroundColor: color, x: x, y: y, disabled: false, onClick: onClick,border: border,));
          continue;
        }
        fields.add(Field(
          backgroundColor: color,
          x: x,
          y: y,
          disabled: disabled,
          onClick: onClick,
          border: Border.all(width: 5,color: Colors.black),
        ));
      }
    }
    return fields;
  }
  void onClick(int x,int y){
    selected.clear();
    selected.add(x);
    selected.add(y);
    changeState((){
      widget=BoardWidget(size: 400, getFields: getFields);
    });
  }


}