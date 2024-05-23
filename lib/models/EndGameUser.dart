class EndGameUser{

  final String id;
  final List<List<int>> fields;
  static EndGameUser fromJson(Map<String,dynamic> data){
    List<dynamic> list=data["fields"];
    List<List<int>> fields=[];
    for(dynamic xd in list){
      fields.add([]);
      for(int x in xd){
        fields.last.add(x);
      }
    }
    return EndGameUser(id: data["id"], fields: fields);
  }
  EndGameUser({required this.id, required this.fields});
}