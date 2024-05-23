import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Modal extends StatelessWidget {
  const Modal({super.key, this.width=350, this.height=200, required this.child, this.backgroundColor=const Color.fromRGBO(15, 39, 3, 1)});
  final int width;
  final int height;
  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: height.toDouble(),
        width: width.toDouble(),
        decoration: BoxDecoration(
            color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: child,
      ),
    );
  }

}
