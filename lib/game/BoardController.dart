import 'package:warships_mobile/newBoards/Board.dart';
import 'package:warships_mobile/newBoards/BoardManager.dart';

class BoardController{
  BoardController(this.setBoard);
  void Function (Board board) setBoard;
  late BoardManager Function () getBoardManager;

  late void Function(bool) setMode;
  late void Function(bool) setPlayerTurn;
}