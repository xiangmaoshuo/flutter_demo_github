import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;

import 'views/demo/index.dart';
import 'tools/event_bus.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  MaterialColor themeColor = Colors.pink;
  @override
  void initState() {
    super.initState();
    bus.on('changeTheme', (color) {
      setState(() {
        themeColor = color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '天歌',
      home: new Demo(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: themeColor,
        bottomAppBarTheme: BottomAppBarTheme(color: themeColor)
      ),
    );
  }
}



// 开始渲染app
void main() => SystemChrome.setPreferredOrientations(
  [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
).then((v) => runApp(new MyApp()));
