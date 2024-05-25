import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warships_mobile/components/Label.dart';
import 'package:warships_mobile/creator/ShipSelector.dart';
import 'package:warships_mobile/creator/SwitchButton.dart';
import 'package:warships_mobile/newBoards/CreatorBoard.dart';

import '../components/Button.dart';

class BottomPanel extends StatelessWidget {
  final void Function() start;
  final void Function(bool mode) changeMode;
  final CreatorBoard board;
  final int selectedShip;
  final Function changeShip;
  final bool removeMode;
  final List<int> shipsLeft;
  final void Function() cancel;

  const BottomPanel(
      {super.key,
      required this.changeMode,
      required this.board,
      required this.selectedShip,
      required this.changeShip,
      required this.start,
      required this.shipsLeft,
      required this.removeMode,
      required this.cancel});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          removeMode
              ? Container(
                  width: 400,
                  height: 170,
                  child: Label(
                    "remove mode enabled",
                    fontSize: 40,
                    color: Colors.red,
                  ),
                )
              : ShipSelector(
                  selectedShip: selectedShip,
                  changeShip: changeShip,
                  shipsLeft: this.shipsLeft,
                  start: start,
                  deploying: board.deployingShip.isNotEmpty,
                ),
          board.deployingShip.isNotEmpty
              ? Container(
                  width: 400,
                  height: 60,
                  child: ElevatedButton(
                      onPressed: cancel,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Label(
                        "cancel",
                        fontSize: 35,
                        color: Colors.black,
                      )),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SwitchButton(
                      changeMode: changeMode,
                      removeMode: board.removeMode,
                    ),
                    Label("change mode", fontSize: 30)
                  ],
                ),
        ]));
  }
}
