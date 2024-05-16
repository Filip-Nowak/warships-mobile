import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({super.key,required this.changeMode, required this.removeMode});
  final void Function(bool mode) changeMode;
  final bool removeMode;
  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  @override
  Widget build(BuildContext context) {
    return  Transform.scale(
      scale: 2,
      child: Switch(
        value: widget.removeMode,
        activeColor: Colors.red,
        onChanged: widget.changeMode,
inactiveTrackColor: Colors.green,

      ),
    );
  }
}
