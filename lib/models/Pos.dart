class Pos{
  final int x;
  final int y;

  Pos({required this.x, required this.y});

  static Pos fromJson(Map<String,dynamic> msg) {
    return Pos(x: msg["x"], y: msg["y"]);
  }
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
}