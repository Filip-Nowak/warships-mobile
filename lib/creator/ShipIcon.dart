import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warships_mobile/components/Label.dart';

class ShipIcon extends StatelessWidget {
  final int size;
  final int left;
  const ShipIcon({super.key, required this.size, required this.left});

  @override
  Widget build(BuildContext context) {
    List<Container> children=[Container(height: 30,width: 30, color: Colors.green,)];
    for(int i=0;i<size-1;i++){
      children.add(Container(height: 10,width: 15,color: Colors.green));
      children.add(Container(height: 30,width: 30,color: Colors.green));
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
          Label("$left left", fontSize: 40)
        ],
      ),
    );
  }
}
