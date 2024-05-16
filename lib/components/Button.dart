import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warships_mobile/components/Label.dart';

class Button extends StatelessWidget {
  final Function onPressed;
  final String message;
  final int fontSize;
  final Color backGroundColor;
  final Color fontColor;
  final bool disabled;
  final BorderSide border;

  const Button(
      {super.key,
      required this.onPressed,
      required this.message,
      this.fontSize = 20,
      this.backGroundColor = const Color.fromRGBO(29, 79, 2, 1.0),
      this.fontColor = const Color.fromRGBO(143, 255, 0, 1.0),
      this.disabled = false,
      this.border=const BorderSide()});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (!disabled) onPressed();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: backGroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), side: border)),
        child: Label(
          message,
          fontSize: fontSize,
          color: fontColor,
        ));
  }
}
