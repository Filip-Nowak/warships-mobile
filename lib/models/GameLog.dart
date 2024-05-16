import 'package:warships_mobile/models/Pos.dart';

class GameLog{
  final String senderId;
  final Pos? pos;
  final String type;

  GameLog({required this.senderId, required this.pos, required this.type});

  static fromJson(Map<String,dynamic> msg) {
    return GameLog(senderId: msg["senderId"], pos: msg["pos"]==null?null:Pos.fromJson(msg["pos"]), type: msg["type"]);
  }
}