import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:warships_mobile/components/Label.dart';
import 'package:warships_mobile/creator/ShipButton.dart';
import 'package:warships_mobile/creator/ShipIcon.dart';

import '../components/Button.dart';

class ShipSelector extends StatefulWidget {
  const ShipSelector(
      {super.key,
      required this.selectedShip,
      required this.changeShip,
      required this.shipsLeft,
      required this.start, required this.deploying, required this.multiplier});

  final int selectedShip;
  final Function changeShip;
  final List<int> shipsLeft;
  final void Function() start;
  final bool deploying;
  final double multiplier;
  @override
  State<ShipSelector> createState() => _ShipSelectorState();
}

class _ShipSelectorState extends State<ShipSelector> {
  void onClick(int number) {
    setState(() {
      blink=false;
    });
    widget.changeShip(number);
  }
  bool blink=true;
  @override
  Widget build(BuildContext context) {
    if(widget.selectedShip == 0 && !blink){
      setState(() {
        blink=true;
      });
    }
    return widget.shipsLeft.every((element) => element == 0)
        ? Column(
            children: [SizedBox(height:25*widget.multiplier,), SizedBox(height: 100*widget.multiplier,width: 300,child: Button(onPressed: widget.start, message: "start"),), SizedBox(height: 45*widget.multiplier,)],
          )
        : Container(
            width: 400,
            height: 170*widget.multiplier,
            child: Column(
              children: [
                Container(
                  height: 39,
                  child: Row(
                    children: [
                      Expanded(
                          child: ShipButton(
                        number: 1,
                        onClick: onClick,
                        selected: widget.selectedShip == 1,
                        disabled: widget.shipsLeft[3] == 0||(widget.deploying&&widget.selectedShip!=1), blink: blink,
                      )),
                      Expanded(
                          child: ShipButton(
                        number: 2,
                        onClick: onClick,
                        selected: widget.selectedShip == 2,
                        disabled: widget.shipsLeft[2] == 0||(widget.deploying&&widget.selectedShip!=2), blink: blink,
                      )),
                      Expanded(
                          child: ShipButton(
                        number: 3,
                        onClick: onClick,
                        selected: widget.selectedShip == 3,
                        disabled: widget.shipsLeft[1] == 0||(widget.deploying&&widget.selectedShip!=3), blink: blink,
                      )),
                      Expanded(
                          child: ShipButton(
                        number: 4,
                        onClick: onClick,
                        selected: widget.selectedShip == 4,
                        disabled: widget.shipsLeft[0] == 0||(widget.deploying&&widget.selectedShip!=4), blink: blink,
                      ))
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.green)),
                  height: 110*widget.multiplier,
                  width: double.infinity,
                  child: widget.selectedShip == 0
                      ? Container(
                          child: Label(
                            "pick ship to deploy",
                            fontSize:( 40*widget.multiplier).toInt(),
                          ),
                        )
                      : ShipIcon(
                          size: widget.selectedShip,
                          left: widget.shipsLeft[4 - widget.selectedShip],
                        ),
                )
              ],
            ),
          );
  }
}
