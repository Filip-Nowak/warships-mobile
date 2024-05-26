import 'dart:math';

import 'package:warships_mobile/models/Pos.dart';

import '../newBoards/Board.dart';

class BotShooter {
  BotShooter(this.handleShot) {
    for (int i = 0; i < 10; i++) {
      possibleLines[i] = [];
      for (int j = 0; j < 10; j++) {
        possibleLines[i]!.add(j);
      }
    }
  }

  Board playerBoard = Board();
  Map<int, List<int>> possibleLines = {};
  List<Pos>? hitShip = null;
  Function handleShot;
  List<Pos> possibleContinues = [];

  takeShot() {
    if (hitShip == null) {
      List<int> pos = this.getRandomPos();
      int x = pos[0];
      int y = pos[1];
      handleShot(Pos(x: x, y: y));
    } else {
      Pos pos = possibleContinues[getRandomNumber(possibleContinues.length)];
      this.handleShot(pos);
    }
  }

  List<int> getRandomPos() {
    List<int> keys = possibleLines.keys.toList();
    int x = keys[getRandomNumber(keys.length)];
    int index = getRandomNumber(possibleLines[x]!.length);
    int y = possibleLines[x]![index];
    return [x, y];
  }

  int getRandomNumber(int max) {
    Random random = Random();
    return random.nextInt(max);
  }

  void shotResult(int result, Pos pos) {
    if (result == 1) {
      if (hitShip == null) {
        hitShip = [];
      }
      this.hitShip!.add(Pos(x: pos.x, y: pos.y));
    } else if (result == 2) {
      if (hitShip == null) {
        this.hitShip = [Pos(x: pos.x, y: pos.y)];
      }
      removePossibleFields();
      hitShip = null;
    }
    removeField(pos.x, pos.y);
    possibleContinues = [];
    if (hitShip != null) {
      if (this.hitShip!.length == 1) {
        possibleContinues = getCrossFields(hitShip![0].x, hitShip![0].y);
      } else {
        Pos first = hitShip![0];
        Pos last = hitShip![0];
        for (int i = 0; i < hitShip!.length; i++) {
          Pos pos1 = hitShip![i];
          if (pos1.x < first.x || pos1.y < first.y) {
            first = pos1;
          }
          if (pos1.x > last.x || pos1.y > last.y) {
            last = pos1;
          }
        }
        if (first.x == last.x) {
          Pos? p1 = checkField(first.x, first.y - 1);
          if (p1 != null) {
            possibleContinues.add(p1);
          }
          p1 = checkField(last.x, last.y + 1);
          if (p1 != null) {
            possibleContinues.add(p1);
          }
        } else {
          Pos? p1 = checkField(first.x - 1, first.y);
          if (p1 != null) {
            possibleContinues.add(p1);
          }
          p1 = checkField(last.x + 1, last.y);
          if (p1 != null) {
            possibleContinues.add(p1);
          }
        }
      }
    }
  }

  void removePossibleFields() {
    for (int i = 0; i < hitShip!.length; i++) {
      Pos pos = hitShip![i];
      for (int k = -1; k < 2; k++) {
        for (int j = -1; j < 2; j++) {
          removeField(pos.x + k, pos.y + j);
        }
      }
    }
  }

  void removeField(int x, int y) {
    List<int>? line = possibleLines[x];
    if (line != null) {
      line.remove(y);

      if (line!.isEmpty) {
        possibleLines.remove(x);
      }
    }
  }

  List<Pos> getCrossFields(int x, int y) {
    List<Pos?> fields = [];
    List<Pos> output = [];
    fields.add(checkField(x + 1, y));
    if (fields.last != null) {
      output.add(fields.last!);
    }
    fields.add(checkField(x - 1, y));
    if (fields.last != null) {
      output.add(fields.last!);
    }
    fields.add(checkField(x, y + 1));
    if (fields.last != null) {
      output.add(fields.last!);
    }
    fields.add(checkField(x, y - 1));
    if (fields.last != null) {
      output.add(fields.last!);
    }
    return output;
  }

  Pos? checkField(int x, int y) {
    List<int>? line = possibleLines[x];
    if (line != null) {
      if (line.contains(y)) {
        return Pos(x: x, y: y);
      }
    }
    return null;
  }
}
