import 'package:warships_mobile/newBoards/Board.dart';

import '../newBoards/BoardWidget.dart';
import 'Field.dart';

abstract class BoardManager{
  Board board=Board();
  bool disabled=false;
  Function changeState = () {};
  int size;
  BoardWidget widget= BoardWidget(size: 0, getFields: (){},);
  List<Field> getFields();
  BoardManager (this.size){
    size=(size / 10).ceil() * 10;
    widget=BoardWidget(size: size, getFields: getFields);
  }
  void setChangeState(Function callback) {
    changeState = callback;
  }
  void update(){
    widget=BoardWidget(size: size, getFields: getFields);
  }
}