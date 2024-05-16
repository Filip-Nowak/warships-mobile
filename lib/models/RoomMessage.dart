class RoomMessage{
  final String senderId;
  final String roomId;
  final dynamic message;

  RoomMessage({required this.senderId, required this.roomId, required this.message});
  Map<String,dynamic> toJson(){
    return {
      "senderId":senderId,
      "roomId":roomId,
      "message":message
    };
  }
}