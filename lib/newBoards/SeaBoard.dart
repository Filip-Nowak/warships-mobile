import 'dart:ui';

import 'package:warships_mobile/newBoards/Board.dart';
import 'package:warships_mobile/newBoards/BoardManager.dart';
import 'package:warships_mobile/newBoards/Field.dart';

class SeaBoard extends BoardManager {
  SeaBoard(super.size, board){
    super.board=board;
  }

  @override
  List<Field> getFields() {
    List<Field> fields = [];
    for (int y = 0; y < 10; y++) {
      for (int x = 0; x < 10; x++) {
        Color color;
        int? value = board.getField(x, y);
        if (value == 0) {
          color = const Color.fromRGBO(30, 126, 255, 1);
        } else if (value == 1) {
          color = const Color.fromRGBO(141, 141, 141, 1);
        } else if (value == 2) {
          color = const Color.fromRGBO(147, 0, 0, 1);
        } else if (value == 3) {
          color = const Color.fromRGBO(66, 0, 0, 1);
        } else {
          color = const Color.fromRGBO(5, 50, 128, 1);
        }

        fields.add(Field(
          backgroundColor: color,
          x: x,
          y: y,
          disabled: true,
          onClick: (){}, width: size/10, height: size/10,
        ));
      }
    }
    return fields;
  }
}
