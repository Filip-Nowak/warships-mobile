import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:warships_mobile/models/GameLog.dart';
import 'package:warships_mobile/models/Pos.dart';
import 'package:warships_mobile/models/Room.dart';
import 'package:warships_mobile/models/RoomMessage.dart';
import 'package:warships_mobile/models/RoomResponse.dart';

class Online {
  Online._privateConstructor();

  static final Online _instance = Online._privateConstructor();

  static Online get instance => _instance;
  String _username = "";
  String _userId = "";
  bool _creator = false;

  bool get creator => _creator;

  set creator(bool value) {
    _creator = value;
  }

  String get username => _username;

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  final String _url = "http://192.168.151.28:8080";
  StompClient? stompClient;
  Room _room = Room("x", [], "x");

  Room get room => _room;

  set room(Room value) {
    _room = value;
  }

  void joinRoom(String code) {
    stompClient!.send(
        destination: "/app/joinRoom",
        body: json.encode(
            RoomMessage(senderId: userId, roomId: code, message: "").toJson()));
  }

  Future<bool> createUser(String username) async {
    final Map<String, dynamic> body = {"nickname": username};

    try {
      print("dziala");
      final response = await http.post(
        Uri.parse("$_url/createUser"),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print("dziala");
      if (response.statusCode == 200) {
        _username = username;
        userId = jsonDecode(response.body)["message"];
        print(_userId);
        return true;
      }
    } catch (e) {
      print(e);
    }

    print("error");
    return false;
  }

  Future<bool> connect(
      {required void Function() onConnect,
      required void Function(dynamic) onError}) async {
    final socketUrl = '$_url/ws?userId=$userId';
    if (stompClient == null) {
      stompClient = StompClient(
          config: StompConfig.sockJS(
        url: socketUrl,
        onConnect: (StompFrame stompFrame) {
          stompClient!.subscribe(
              destination: "/user/$userId/room", callback: handleRoomMessage);
          stompClient!.subscribe(
              destination: "/user/$userId/game", callback: handleGameLog);
          onConnect();
        },
        onWebSocketError: onError,
      ));
      stompClient!.activate();
    }
    return false;
  }

  void handleRoomMessage(StompFrame frame) {
    if (frame.body != null) {
      print("ROOM MESSAGE");
      print(frame.body);
      print("");
      RoomResponse message = RoomResponse.fromJson(json.decode(frame.body!));
      if (roomMessageHandlers[message.type] != null) {
        roomMessageHandlers[message.type]!(message.message);
      }
    }
  }

  void handleGameLog(StompFrame frame) {
    if (frame.body != null) {
      print("GAME LOG");
      print(frame.body);
      print("");
      GameLog message = GameLog.fromJson(json.decode(frame.body!));
      if (gameLogHandlers[message.type] != null) {
        gameLogHandlers[message.type]!(message);
      }
    }
  }

  void addRoomMessageHandler(String type, void Function(String) callback) {
    roomMessageHandlers[type] = callback;
  }

  void addGameLogHandler(String type, void Function(GameLog) callback) {
    gameLogHandlers[type] = callback;
  }

  Map<String, void Function(String msg)> roomMessageHandlers = {};
  Map<String, void Function(GameLog msg)> gameLogHandlers = {};

  void setReady(bool value) {
    stompClient!.send(
        destination: "/app/ready",
        body: json.encode(RoomMessage(
                senderId: userId, roomId: room.id, message: value.toString())
            .toJson()));
  }

  void createRoom() {
    stompClient!.send(
        destination: "/app/createRoom",
        body: json.encode(
            RoomMessage(senderId: userId, roomId: "", message: "").toJson()));
  }

  void shoot(Pos? pos) {
    RoomMessage message = RoomMessage(
        senderId: userId,
        roomId: room.id,
        message: pos == null ? "" : "${pos.x};${pos.y}");
    print("sending");
    print(message);
    stompClient!.send(destination: "/app/shoot", body: json.encode(message));
  }

  void submitShips(List<List<int>> fields) {
    bool noShips = true;
    print("checking");
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        if (fields[j][i] != 0) {
          noShips = false;
          break;
        }
      }
      if (!noShips) break;
    }
    RoomMessage msg = RoomMessage(
        senderId: userId,
        roomId: room.id,
        message: noShips ? "" : jsonEncode(fields));
    print("sending");
    stompClient!.send(destination: "/app/submitShips", body: json.encode(msg));
  }
}
