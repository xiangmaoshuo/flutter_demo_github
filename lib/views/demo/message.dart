import 'package:flutter/material.dart';

class MessageDemo extends StatefulWidget {
  MessageDemo({this.text = '再按一次退出程序', Key key}):super(key: key);
  final String text;

  @override
  State<MessageDemo> createState() {
    return new _MessageDemoState();
  }
}

class _MessageDemoState extends State<MessageDemo> {
  DateTime _lastTime;
  bool showMsg = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (_lastTime == null || now.difference(_lastTime) > Duration(seconds: 1)) {
          _lastTime = now;
          setState(() {
           showMsg = true;
          });
          Future.delayed(Duration(seconds: 1)).then((v) {
            setState(() {
            showMsg = false; 
            });
          });
          return false;
        }
        return true;
      },
      child: Positioned(
        bottom: 80.0,
        left: 0,
        right: 0,
        child: showMsg ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.black12,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                child: Text(widget.text, style: TextStyle(
                  fontSize: 12.0
                ),),
              ),
            )
          ],
        ) : SizedBox(),
      ),
    );
  }
}
