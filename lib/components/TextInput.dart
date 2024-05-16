import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextInput extends StatefulWidget {
  const TextInput({super.key, required this.onClick, required this.fontSize});
  final Function onClick;
  final int fontSize;
  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
    String content="";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 5, color: Colors.black)),
            width: 240,
            child: TextField(
              style: TextStyle(
                fontSize: widget.fontSize.toDouble(),
                fontFamily: "arcade",
                color: const Color.fromRGBO(143, 255, 0, 1.0),
              ),
              decoration: InputDecoration(

              ),
              onChanged: (text){
                setState(() {
                  content=text;
                });
              },
            ),
          ),
          Container(
              decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(width: 5, color: Colors.black),
                    top: BorderSide(width: 5, color: Colors.black),
                    bottom: BorderSide(width: 5, color: Colors.black)),
              ),
              child:
                  IconButton(onPressed: (){if(content.isNotEmpty)widget.onClick(content);}, icon: Icon(Icons.arrow_forward,color: content.isEmpty?Colors.black:Colors.green,)))
        ],
      ),
    );
  }

}
