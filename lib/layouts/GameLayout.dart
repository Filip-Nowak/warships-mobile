import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warships_mobile/game/GameView.dart';
import 'package:warships_mobile/game/GameViewController.dart';

class GameLayout extends StatelessWidget {
  GameLayout({super.key});

  final GameView view = GameView(gameViewController: GameViewController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(body: view);
  }
}

// import 'package:warships_mobile/utils/UserDetails.dart';
//
// class GameLayout extends StatefulWidget {
//   const GameLayout({super.key});
//
//   @override
//   State<GameLayout> createState() => _GameLayoutState();
// }
//
// class _GameLayoutState extends State<GameLayout> {
//   bool consoleMode = false;
//   SeaBoard seaBoard = SeaBoard(400, UserDetails.instance.board);
//   List<int> selected=[];
//   ConsoleBoard consoleBoard = ConsoleBoard(400);
//
//   void changeState(Function callback) {
//     setState(() {
//       callback();
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     consoleBoard.setChangeState(changeState);
//     consoleBoard.setSelected(selected);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("render");
//     print(selected);
//     return Scaffold(
//       body: Stack(children: [
//         Container(
//           width: double.infinity,
//           color: Color.fromRGBO(30, 109, 226, 1),
//           child: Column(
//             children: [
//               GameInfo(),
//               SizedBox(
//                 height: 60,
//               ),
//               Label("your ships",
//                   fontSize: 50, color: Color.fromRGBO(5, 50, 128, 1)),
//               SizedBox(
//                 height: 20,
//               ),
//               seaBoard.widget,
//             ],
//           ),
//         ),
//         Positioned(
//           bottom: consoleMode ? 0 : -500,
//           left: MediaQuery.of(context).size.width / 2 - 210,
//           child: ConsolePanel(
//             setMode: (mode) {
//               setState(() {
//                 this.consoleMode = mode;
//               });
//             },
//             board: consoleBoard.widget,
//             picked: selected.isNotEmpty, mode: false,
//           ),
//         )
//       ]),
//     );
//   }
// }
