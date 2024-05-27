import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:warships_mobile/newBoards/BoardWidget.dart';
import 'package:warships_mobile/newBoards/Field.dart';

import 'BoardManager.dart';

class CreatorBoard extends BoardManager {
  CreatorBoard(super.size);

  bool removeMode = false;
  List<List<int>> deployingShip = [];
  int selectedShip = 0;
  Function addShip = () {};
  Function removeShip = () {};

  @override
  List<Field> getFields() {
    print(size);
    List<Field> fields = [];
    for (int y = 0; y < 10; y++) {
      for (int x = 0; x < 10; x++) {
        bool fieldDisabled = true;
        bool border = false;
        Color color;
        int? value = board.getField(x, y);
        if (value == 0) {
          border = true;
          color = const Color.fromRGBO(1, 9, 3, 1);
          fieldDisabled = !(deployingShip.isEmpty&&selectedShip!=0);
        } else if (value == 1) {
          if (removeMode) {
            fieldDisabled = false;
            color = Colors.red;
          } else {
            color = const Color.fromRGBO(27, 192, 0, 1);
          }
        } else if (value == 2) {
          color = const Color.fromRGBO(255, 255, 0, 1);
        } else if (value == 3) {
          fieldDisabled = deployingShip.isEmpty;
          color = const Color.fromRGBO(0, 0, 255, 1);
        } else {
          if (removeMode) {
            color = const Color.fromRGBO(1, 9, 3, 1);
            border=true;
          } else {
            color = const Color.fromRGBO(51, 0, 0, 1);
          }
        }
        fields.add(border
            ? Field(
                backgroundColor: color,
                x: x,
                y: y,
                disabled: disabled || fieldDisabled,
                onClick: onClick,
                border:
                    Border.all(width: 2, color: Color.fromRGBO(0, 24, 1, 1)), width: size/10, height: size/10,)
            : Field(
                backgroundColor: color,
                x: x,
                y: y,
                disabled: disabled || fieldDisabled,
                onClick: onClick, width: size/10, height: size/10,
              ));
      }
    }
    return fields;
  }

  void setSelectedShip(int ship) {
    selectedShip = ship;
  }

  void setAddShip(Function callback) {
    addShip = callback;
  }

  void setRemoveShip(Function callback) {
    removeShip = callback;
  }

  void onClick(int x, int y) {
    if (!removeMode) {
      // board.setField(x, y, 1);
      // changeState(()=>{
      //   widget=BoardWidget(size: widget.size, getFields: getFields)
      // });
      pickField(x, y);
    } else {
      remove(x, y);
    }
  }
  void resetFields(int x,int y){
    board.forAroundFields(x, y, (x, y) {
      if (board.checkAroundFields(x, y, (value) => value != 1)) {
        board.setField(x, y, 0);
      }
    });
  }
  void remove(int x, int y) {
    List<List<int>> ship = [];
    callback(int x, int y) {
      if (board.getField(x, y) == 1) {
        board.setField(x, y, 0);
        ship.add([x, y]);
        board.forCrossFields(x, y, callback);
      }
    }

    callback(x, y);
    if (ship.length == 1) {
      resetFields(x, y);
    } else {
      sortShip(ship);
      resetFields(ship[0][0], ship[0][1]);
      resetFields(ship.last[0], ship.last[1]);
    }
    removeShip(ship.length);
    changeState(() {
      widget = BoardWidget(size: widget.size, getFields: getFields);
    });
  }
  void sortShip(List<List<int>> ship){
    int index=0;
    if(ship[0][0]==ship[1][0]){
      index=1;
    }
      int n = ship.length;
      for (int i = 0; i < n - 1; i++)
        {
          for (int j = 0; j < n - i - 1; j++) {
            if (ship[j][index] > ship[j + 1][index]) {
              // swap temp and arr[i]
              int temp = ship[j][index];
              ship[j][index] = ship[j + 1][index];
              ship[j + 1][index] = temp;
            }
          }
        }

  }


  void pickField(int x, int y) {
    board.setField(x, y, 2);
    deployingShip.add([x, y]);

    if (deployingShip.length == selectedShip) {
      for (List<int> field in deployingShip) {
        board.setField(field[0], field[1], 1);
        board.forAroundFields(field[0], field[1], (x, y) {
          if (board.getField(x, y) != 1) {
            board.setField(x, y, 4);
          }
        });
      }
      addShip();
      deployingShip = [];
    } else if (deployingShip.length == 1) {
      board.forCrossFields(x, y, (x, y) {
        if (board.getField(x, y) == 0) {
          board.setField(x, y, 3);
        }
      });
    } else {
      if (deployingShip.length == 2) {
        List pos = deployingShip[0];
        board.forCrossFields(pos[0], pos[1], (x1, y1) {
          if (board.getField(x1, y1) != 4 && !(x1 == x && y1 == y)) {
            board.setField(x1, y1, 0);
          }
          ;
        });
      }

      for (List field in deployingShip) {
        int counter = 0;
        List<int> pos = [];
        callback(x, y) {
          if (board.getField(x, y) == 2) {
            counter++;
            pos = [x, y];
          }
        }

        board.forCrossFields(field[0], field[1], callback);
        if (counter == 1) {
          int x = field[0] + field[0] - pos[0];
          int y = field[1] + field[1] - pos[1];
          if (board.getField(x, y) == 0) {
            board.setField(x, y, 3);
          }
        }
      }
    }
    changeState(
        () => {widget = BoardWidget(size: widget.size, getFields: getFields)});
  }
  void cancel(){
    for(List<int> field in deployingShip){
      board.setField(field[0],field[1],0);
      board.forCrossFields(field[0], field[1], (x, y) {
        if((board.getField(x,y)==3||board.getField(x,y)==2)){
          board.setField(x, y, 0);
        }
      });
    }
    deployingShip=[];
  }
}
