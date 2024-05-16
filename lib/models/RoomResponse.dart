class RoomResponse{
  final String message;
  final String type;

  RoomResponse(this.message, this.type);
  static RoomResponse fromJson(Map<String, dynamic> msg){
    return RoomResponse(msg["message"], msg["type"]);
  }
}