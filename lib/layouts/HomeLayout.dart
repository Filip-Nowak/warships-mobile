import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:warships_mobile/components/Button.dart';
import 'package:warships_mobile/components/Label.dart';
import 'package:warships_mobile/components/Modal.dart';
import 'package:warships_mobile/components/TextInputField.dart';
import 'package:warships_mobile/utils/Online.dart';
import 'package:warships_mobile/utils/UserDetails.dart';

import '../newBoards/Board.dart';


class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  void handleOnlineClick(String username, BuildContext context) {
    setState(() {
      _isLoading=true;
    });
    Online.instance.createUser(username,context).then((value)  {
      if (value) {
            Online.instance.connect(onConnect: (){onConnect(context);},context: context);
          }else{
        setState(() {
          _isLoading=false;
        });
      }
        });
  }

  void onConnect(BuildContext context){
    setState(() {
      _isLoading=false;
    });
    Navigator.pop(context);
    UserDetails.instance.online=true;
    print(UserDetails.instance.online);
    Navigator.pushNamed(context, "/createRoom");
  }

  void onError(dynamic error){
    setState(() {
      _isLoading=false;
    });
    print(error);
  }

  void handleBotClick(BuildContext context) {
    UserDetails.instance.back=( ){
      UserDetails.instance.board=Board();
      Online.instance.creator=false;
      Navigator.pop(context);
    };
    Navigator.pushNamed(context, "/creator");
  }

  bool _isLoading=false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Stack(
      children: [Scaffold(

          backgroundColor: Color.fromRGBO(30, 0, 116, 1),
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 200,),
                  const Label(
                    "warships",
                    fontSize: 70,
                  ),
                  const SizedBox(
                    height: 300,
                  ),
                  Button(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Modal(
                              width: 400,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(children: [
                                  Label(
                                    "type in your nickname",
                                    fontSize: 40,
                                  ),
                                  TextInputField(
                                    fontSize: 40,
                                    onClick: (text) {
                                      handleOnlineClick(text, context);
                                    },
                                  )
                                ]),
                              ),
                            );
                          });
                    },
                    message: "play online",
                    fontSize: 50,
                  ),
                  const SizedBox(height: 30),
                  Button(
                    onPressed: () {
                      handleBotClick(context);
                    },
                    message: "play vs bot",
                    fontSize: 50,
                  ),
                ],
              ),
            ),
          )),
        if (_isLoading)
          AbsorbPointer(
            child: Stack(
              children: [
                ModalBarrier(dismissible: false, color: Colors.black.withOpacity(0.5)),
                Center(
                  child: CircularProgressIndicator(color: Color.fromRGBO(143, 255, 0, 1.0),),
                ),
              ],
            ),
          ),
      ]);
  }
}
