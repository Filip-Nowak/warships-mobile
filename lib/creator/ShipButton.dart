import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/Label.dart';

// class ShipButton extends StatelessWidget {
//   final int number;
//   final bool selected;
//   final void Function(int) onClick;
//   final bool disabled;
//   const ShipButton({super.key, required this.number,required this.onClick, required this.selected, required this.disabled});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         if(!disabled) {
//           onClick(number);
//         }},
//       child: Container(
//         color:!selected?Color.fromRGBO(0, 0, 0, 0):Colors.green,
//         child:!(selected||disabled)?Label(number.toString(), fontSize: 30,):Label(number.toString(), fontSize: 30,color: Colors.black)
//       ),
//     );
//   }
// }


class ShipButton extends StatefulWidget {
  final int number;
  final bool selected;
  final void Function(int) onClick;
  final bool disabled;
  final bool blink;
  const ShipButton({super.key, required this.number,required this.onClick, required this.selected, required this.disabled, required this.blink});
  @override
  _ShipButtonState createState() => _ShipButtonState();
}

class _ShipButtonState extends State<ShipButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  bool animation=false;
  @override
  Widget build(BuildContext context) {
    print("blink");
    print(widget.blink);
    if(!widget.blink){
      if(animation){
        setState(() {
          // _controller.stop();
          _controller.reset();
          animation=false;
        });
      }
    }else{
      if(!animation && !widget.disabled){
        setState(() {
          _controller.stop();
          _controller.repeat(reverse: true);
          animation=true;
        });

      }
    }
    return FadeTransition(
      opacity: _animation,
      child: GestureDetector(
        onTap: (){
          if(!widget.disabled) {
            widget.onClick(widget.number);
          }},
        child: Container(
            color:!widget.selected?Color.fromRGBO(0, 0, 0, 0):Colors.green,
            child:!(widget.selected||widget.disabled)?Label(widget.number.toString(), fontSize: 30,):Label(widget.number.toString(), fontSize: 30,color: Colors.black)
        ),
      ),
    );
  }
}
