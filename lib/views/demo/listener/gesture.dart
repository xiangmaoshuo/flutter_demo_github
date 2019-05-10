// doc: https://book.flutterchina.club/chapter8/gesture.html

import 'package:flutter/material.dart';
import 'dart:math' as math;

class GestureDemo extends StatefulWidget {
  @override
  State<GestureDemo> createState() {
    return new _GestureDemoState();
  }
}

class _GestureDemoState extends State<GestureDemo> {
  double _top = 100.0;
  double _left = 50.0;
  String _operation = "No Gesture detected!"; //保存事件名

  void updateText(String text) {
    //更新显示的事件名
    setState(() {
      _operation = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Builder(
                builder: (context) {
                  return Stack(
                    children: <Widget>[
                      Positioned(
                        top: _top,
                        left: _left,
                        child: GestureDetector( // GestureDetector 支持很多事件，点击，双击，长按，缩放，滑动...
                          child: CircleAvatar(
                            child: Icon(Icons.accessibility),
                          ),
                          onPanDown: (DragDownDetails e) {
                            print(context.size.width);
                            print('用户手指按下： ${e.globalPosition}');
                          },
                          // 该事件是手指滑动时会触发，要指定方向使用onVerticalDragUpdate/onHorizontalDragUpdate
                          onPanUpdate: (DragUpdateDetails e) {
                            // 本例判断了边界
                            final width = context.size.width - 40;
                            final height = context.size.height - 40;
                            final left = _left + e.delta.dx;
                            final top = _top + e.delta.dy;
                            setState(() {
                              _left = left >= 0 ? math.min(width, left) : 0;
                              _top = top >= 0 ? math.min(height, top) : 0;
                            });
                          },
                          onPanEnd: (DragEndDetails e) {
                            print(e.velocity);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Divider(color: Colors.pink,),
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.blue, // 这里color 起到了扩大PointEvent命中测试范围的效果，详见本文件同目录下pointer.dart
                  width: 200.0, 
                  child: Text(_operation),
                ),
                onTap: () => updateText("Tap"),//点击
                onDoubleTap: () => updateText("DoubleTap"), //双击
                onLongPress: () => updateText("LongPress"), //长按,
              ),
            )
          ],
        ),
      ),
    );
  }
}
