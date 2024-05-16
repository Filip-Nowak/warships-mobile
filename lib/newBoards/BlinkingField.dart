import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlinkingField extends StatefulWidget {
  const BlinkingField({super.key, required this.backgroundColor, required this.x, required this.y, required this.disabled, required this.onClick});
  final Color backgroundColor;
  final int x;
  final int y;
  final bool disabled;
  final Function onClick;
  @override
  State<BlinkingField> createState() => _BlinkingFieldState();
}

class _BlinkingFieldState extends State<BlinkingField> {
  late Timer timer;
  bool showBorder=true;
  late Border border=Border.all(width: 5,color: Colors.green);
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      setState(() {
        showBorder=!showBorder;
        if(showBorder){
          border=Border.all(width: 5,color: Colors.green);
        }else{
          border=Border.all(width: 5,color: Colors.black);
        }
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
  handleClick() {
    if (!widget.disabled) {
      widget.onClick(widget.x, widget.y);
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleClick(),
      child:
      Container(
        decoration:
        BoxDecoration(color: this.widget.backgroundColor, border: this.border),

      ),
    );
  }
}
