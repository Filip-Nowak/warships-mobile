class User{
  User(this.id,this.nickname,this.ready);
  String id;
  String nickname;
  bool ready;
  static User fromJson(Map<String,dynamic> msg){
    return User(msg["id"], msg["nickname"], msg["ready"]);
  }
}