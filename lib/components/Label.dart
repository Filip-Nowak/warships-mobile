import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String message;
  final int fontSize;
  const Label(this.message,{required this.fontSize,super.key, this.color=const Color.fromRGBO(143, 255, 0, 1.0)});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize.toDouble(),
          fontFamily: "arcade",
          color: color,
        ),
    );
  }
}
