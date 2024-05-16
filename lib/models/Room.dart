import 'User.dart';

class Room{

  String id;
  List<User> users;
  String ownerId;
  Room(this.id, this.users, this.ownerId);

  static Room fromJson(Map<String,dynamic> msg){
    List<User> users=[];
    List<dynamic> list=msg["users"];
    for(int i=0;i<list.length;i++){
      users.add(User(list[i]["id"], list[i]["nickname"], list[i]["ready"]));
    }
    return Room(msg["id"], users, msg["ownerId"]);
  }
  User? getUser(String id){
    for(User user in users){
      if(user.id==id){
        return user;
      }
    }
  }
}