import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warships_mobile/newBoards/BlinkingField.dart';

class Field extends StatelessWidget {
  final Color backgroundColor;
  final Border border;
  final int x;
  final int y;
  final bool disabled;
  final Function onClick;
  final bool blink;

  const Field({
    super.key,
    required this.backgroundColor,
    this.border = const Border(),
    required this.x,
    required this.y,
    required this.disabled,
    required this.onClick,
    this.blink = false,
  });

  handleClick() {
    if (!disabled) {
      onClick(x, y);
    }
  }

  @override
  Widget build(BuildContext context) {
    return !blink
        ? GestureDetector(
            onTap: handleClick,
            child: Container(
              decoration: BoxDecoration(
                  color: this.backgroundColor, border: this.border),
            ),
          )
        : BlinkingField(
            disabled: disabled,
            backgroundColor: backgroundColor,
            x: x,
            y: y,
            onClick: onClick,
          );
  }
}
