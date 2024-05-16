import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/Label.dart';

class ShipButton extends StatelessWidget {
  final int number;
  final bool selected;
  final void Function(int) onClick;
  final bool disabled;
  const ShipButton({super.key, required this.number,required this.onClick, required this.selected, required this.disabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(!disabled) {
          onClick(number);
        }},
      child: Container(
        color:!selected?Color.fromRGBO(0, 0, 0, 0):Colors.green,
        child:!(selected||disabled)?Label(number.toString(), fontSize: 30,):Label(number.toString(), fontSize: 30,color: Colors.black)
      ),
    );
  }
}
