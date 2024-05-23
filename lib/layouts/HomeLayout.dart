import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:warships_mobile/components/Button.dart';
import 'package:warships_mobile/components/Label.dart';
import 'package:warships_mobile/components/Modal.dart';
import 'package:warships_mobile/components/TextInput.dart';
import 'package:warships_mobile/utils/Online.dart';
import 'package:warships_mobile/utils/UserDetails.dart';

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
    Online.instance.createUser(username).then((value)  {
      if (value) {
            Online.instance.connect(onConnect: (){onConnect(context);},onError: onError);
          }
        });
  }

  void onConnect(BuildContext context){
    setState(() {
      _isLoading=false;
    });
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
    Navigator.pushNamed(context, "/creator");
  }

  bool _isLoading=false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [Scaffold(
          backgroundColor: Color.fromRGBO(30, 0, 116, 1),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Label(
                  "warships",
                  fontSize: 80,
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
                                TextInput(
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
