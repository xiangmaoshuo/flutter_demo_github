// doc: https://book.flutterchina.club/chapter8/gesture.html

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
/*
 * 手势识别时，有时候会导致手势竞争/冲突，当出现这种情况时，如果又必须这么做，那么可以通过Listener来监听原始指针事件来解决
 */
class GestureDemo extends StatefulWidget {
  @override
  State<GestureDemo> createState() {
    return new _GestureDemoState();
  }
}

class _GestureDemoState extends State<GestureDemo> {
  double _top = 100.0;
  double _left = 50.0;
  double _width = 200.0;
  int _colorIndex = 0;
  // 记得在widget销毁时执行dispose
  TapGestureRecognizer _tapGestureRecognizer = new TapGestureRecognizer();

  String _operation = "No Gesture detected!"; //保存事件名

  void updateText(String text) {
    //更新显示的事件名
    setState(() {
      _operation = text;
    });
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // 滚动的百分比
            print('${(notification.metrics.pixels / notification.metrics.maxScrollExtent * 100).toStringAsFixed(2)}%');
            return true; // 是否阻止通知冒泡， true即阻止
          },
          // 通知的监听可以传一个监听的对象T，T需要是Notification类的子类，所以有时候我们如果需要做自定义通知，只需要定义一个子类继承自Notification即可
          // 如果遇到监听通知的回调没有被调用，那么8成是context上下文出了问题
          child: NotificationListener<MyNotification>(
            onNotification: (notification) {
              print(notification.msg);
              return true; // 这里虽然返回了true，但是监听的通知类型为MyNotification，所以不会阻止上面的ScrollNotification通知（应该不会，没有测试，哈哈）
            },
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 340,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: _top,
                        left: _left,
                        child: GestureDetector( // GestureDetector 支持很多事件，点击，双击，长按，缩放，滑动...
                          child: CircleAvatar(
                            child: Icon(Icons.accessibility),
                          ),
                          // 该事件是手指滑动时会触发，要指定方向使用onVerticalDragUpdate/onHorizontalDragUpdate
                          onPanUpdate: (DragUpdateDetails e) {
                            // 本例判断了边界
                            final left = _left + e.delta.dx;
                            final top = _top + e.delta.dy;
                            setState(() {
                              _left = left.clamp(0, context.size.width - 40);
                              _top = top.clamp(0, 300.0);
                            });
                          },
                          onPanEnd: (DragEndDetails e) {
                            print(e.velocity);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.pink,),
                SizedBox(
                  height: 300,
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
                ),
                Divider(color: Colors.pink,),
                SizedBox(
                  height: 340,
                  child: Center(
                    child: GestureDetector(
                      child: Image.asset('lib/images/demo.jpg', width: _width,),
                      onScaleUpdate: (details) {
                        setState(() {
                        _width = 200*details.scale.clamp(.8, 10.0);
                        });
                      },
                    ),
                  ),
                ),
                // 这里做了点击变色
                Builder(
                  builder: (context) {
                    return Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: '我会'),
                          TextSpan(
                            text: '变色',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.primaries[_colorIndex % Colors.primaries.length],
                            ),
                            recognizer: _tapGestureRecognizer
                            ..onTap = () {
                              MyNotification('color change').dispatch(context);
                              setState(() {
                                _colorIndex ++;
                              });
                            }
                          ),
                          TextSpan(text: '噢！'),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 自定义通知举例
class MyNotification extends Notification {
  final String msg;
  MyNotification(this.msg):super();
}
