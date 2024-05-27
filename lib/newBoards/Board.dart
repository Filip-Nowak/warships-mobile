class Board {
  List<List<int>> fields =
      List.generate(10, (_) => List.generate(10, (_) => 0));
  Board(){}
  Board.clone(Board board){
    for(int i=0;i<10;i++){
      for(int j=0;j<10;j++){
        fields[i][j]=board.fields[i][j];
      }
    }
  }
  void setField(int x, int y, int value) {
    if (!checkField(x, y)) {
      return;
    }
    fields[y][x] = value;
  }

  int? getField(int x, int y) {
    if (checkField(x, y)) {
      return fields[y][x];
    }
    return null;
  }

  bool checkField(int x, int y) {
    return x >= 0 && y >= 0 && x < 10 && y < 10;
  }

  void forCrossFields(int x, int y, void Function(int x, int y) callback) {
    if (checkField(x + 1, y)) {
      callback(x + 1, y);
    }
    if (checkField(x - 1, y)) {
      callback(x - 1, y);
    }
    if (checkField(x, y + 1)) {
      callback(x, y + 1);
    }
    if (checkField(x, y - 1)) {
      callback(x, y - 1);
    }
  }

  void forAroundFields(int x, int y, void Function(int x, int y) callback) {
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        callback(x + i, y + j);
      }
    }
  }

  bool checkAroundFields(int x, int y, bool Function(int value) condition) {
    bool output = true;
    forAroundFields(x, y, (x, y) {
      int? field = getField(x, y);
      if (field != null) {
        if (!condition(field)) {
          output = false;
        }
      }
    });
    return output;
  }

  void  transformToSea() {
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        if (fields[i][j] == 4 || fields[i][j] == 3 || fields[i][j]==2) {
          fields[i][j] = 0;
        }
      }
    }
  }

  Board clone() {
    return Board.clone(this);
  }
}
