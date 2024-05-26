import 'dart:math';

import 'package:warships_mobile/models/Pos.dart';
import 'package:warships_mobile/newBoards/Board.dart';

import 'BotShooter.dart';

class Bot {
  Board board = Board();
  late BotShooter botShooter;
  Bot(Function handleShot) {
    generateRandomFields();
    print(board.fields);
    for(int i=0;i<10;i++){
      print(board.fields[i]);
    }
    botShooter=BotShooter(handleShot);
  }

  int getRandomNumber(int max) {
    Random random = Random();
    return random.nextInt(max);
  }

  void generateRandomFields() {
    addShip(4);
    addShip(3);
    addShip(3);
    addShip(2);
    addShip(2);
    addShip(2);
    addShip(1);
    addShip(1);
    addShip(1);
    addShip(1);
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        if (board.getField(i, j) == 2) {
          board.setField(i, j, 0);
        }
      }
    }
  }

  void addShip(int size) {
    List<int> possible = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    List<int> line = [];
    int index;
    bool axis;
    while (true) {
      List<dynamic> xd = getLine(possible);
      List<List<int>> lines = xd[1];
      int checkingIndex = xd[0];
      if (isLinePossible(lines[0], size)) {
        index = checkingIndex;
        line = lines[0];
        axis = line == board.fields[index];
        break;
      }
      if (isLinePossible(lines[1], size)) {
        index = checkingIndex;
        line = lines[1];
        axis = line == board.fields[index];
        break;

      }
      possible.remove(checkingIndex);
    }
    List<int> possiblePositions = getShipPos(line, size);
    int pos= possiblePositions[getRandomNumber(possiblePositions.length)];
    deployShip(index,axis,size,pos);
  }

  List<dynamic> getLine(List<int> possible) {
    int index = possible[getRandomNumber(possible.length)];
    int axis = getRandomNumber(2);
    List<List<int>> output = [];
    output.add(board.fields[index]);
    List<int> line = [];
    for (int i = 0; i < 10; i++) {
      line.add(board.fields[i][index]);
    }
    output.insert(axis, line);
    return [index, output];
  }

  bool isLinePossible(List<int> line, int size) {
    int counter = 0;
    for (int i = 0; i < 10; i++) {
      if (line[i] == 0) {
        counter++;
        if (counter == size) {
          return true;
        }
      } else {
        counter = 0;
      }
    }
    if (counter == size) {
      return true;
    }
    return false;
  }

  List<int> getShipPos(List<int> line, int size) {
    List<int> ships = [];
    int counter = 0;
    int? index = null;
    for (int i = 0; i < 10; i++) {
      if (line[i] == 0) {
        if (index == null) {
          index = i;
        }
        counter++;
      } else {
        if (counter >= size) {
          for (int j = 0; j < counter - size + 1; j++) {
            if (index != null) {
              ships.add(index + j);
            } else {
              throw Exception();
            }
          }
        }
        index=null;
        counter=0;
      }
    }
    if(counter!=0){
      if(counter >=size){
        for(int j=0;j<counter - size + 1;j++){
          if(index!=null)
          {
            ships.add(index + j);
          }else{
            throw Exception();
          }
        }
      }
    }
    return ships;
  }

  void deployShip(int index, bool axis, int size, int pos) {
    if(axis){
      for(int i=0;i<size;i++){
        board.fields[index][pos+i]=1;
        board.forAroundFields(pos+i, index, (x, y) {
          if(board.getField(x, y)!=1){
            board.setField(x, y, 2);
          }
        });
      }
    }else{
      for(int i=0;i<size;i++){
        board.fields[pos+i][index]=1;
        board.forAroundFields(index, pos + i,  (x, y){
        if (board.getField(x, y) != 1) {
            board.setField(x, y, 2);
      }
    });
      }
    }
  }

  Map<String,bool> shoot(Pos pos){
    int x=pos.x;
    int y=pos.y;
    Map<String,bool>output={};
    final firstField=board.fields[y][x];
    if(board.fields[y][x]==1){
      board.fields[y][x]=2;
      bool sunken=true;
      Board cloned = this.board.clone();
      callback(x,y){
        print("checking $x $y");
        print(cloned.getField(x, y));
        for(int i=0;i<10;i++){
          print(cloned.fields[i]);
        }
        if(cloned.getField(x, y)==2){
          print("equals 2");
          cloned.fields[y][x]=5;
          cloned.forCrossFields(x, y, callback);
        }else if(cloned.getField(x, y)==1){
          print("equals 1");
          sunken=false;
        }
      }
      cloned.forCrossFields(x, y, callback);
      for(int i=0;i<10;i++){
        print(board.fields[i]);
      }
      if(sunken){
        xd(x, y) {
          if (board.getField(x, y) == 2) {
            board.setField(x, y, 3);
            board.forCrossFields(x, y, xd);
          }
        }

        board.setField(x, y, 3);
        board.forCrossFields(x, y, xd);
      }
      output={"hit":true,"sunken":sunken,"alreadyHit":false};
    }else{
      output={"hit":false,"sunken":false,"alreadyHit":firstField==2 || firstField==3};
    }

    print("output: ");
    print(output);
    return output;
  }
  takeShot(){
    botShooter.takeShot();
  }
  shotResult(result,pos){
    botShooter.shotResult(result, pos);
  }
}
