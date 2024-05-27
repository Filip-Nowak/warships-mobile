import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Field.dart';

class BoardWidget extends StatelessWidget {
  final int size;
  // final List<Field> fields;
  final Function getFields;
  const BoardWidget({super.key, required this.size, required this.getFields});

  @override
  Widget build(BuildContext context) {
    print("render3");
    return Container(
      width: size.toDouble(),
      height: size.toDouble(),
      child: GridView.count(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 10,
          children:getFields()
      ),
    );
  }

}
