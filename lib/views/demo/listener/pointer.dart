import 'package:flutter/material.dart';

class PointerDemo extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        children: <Widget>[
          Listener(
            child: Container(
              height: 150,
              child: Text('点击整个框框都会触发'),
            ),
            onPointerDown: (e) {
              print('此时Text大小和Container大小一样大，所以会触发');
            },
          ),
          Divider(),
          Listener(
            child: Container(
              height: 150,
              // decoration: BoxDecoration(
              //   // border: Border.all()
              // ),
              color: Colors.pink,
              child: Center(
                child: Text('点击整个框框都会触发'),
              )
            ),
            onPointerDown: (e) {
              print(
                '此时虽然Text的大小是其自身大小，但是由于Container本身添加有一些样式，'
                '如背景/边框等，导致界面上能够很明显的看到点击范围是否在Container内，所以还是会响应的，'
                '测试发现仅仅添加参数decoration: BoxDecoration()也会响应，如果想只在Text上响应，可以'
                '将color注释掉即可'
              );
            },
          ),
          Divider(),
          Listener(
            child: ConstrainedBox(
                constraints: BoxConstraints.tight(Size(300.0, 150.0)),
                child: Center(child: Text("点击整个框框都会触发")),
            ),
            behavior: HitTestBehavior.opaque,
            onPointerDown: (event) => print(
              '这个就是既没有让Text大小和外部盒子一样大，也没有让外部盒子有背景/边框等样式，按道理他是只会在点击Text本身时才会响应事件的，\n'
              '但是Listener本身支持behavior参数，该参数为HitTestBehavior枚举类型，有三个值：deferToChild（默认）, opaque（使不透明），translucent（点透）;\n'
              '默认值的特点上面的demo其实也在说明了，就是先进行命中测试，然后有命中测试发现的最内部的widget开始冒泡；\n'
              '第二个就是在第一个的情况下增大了命中面积，只要是在widget的面积范围内都会触发相应事件;\n'
              '第三个就是在第二个的基础上，可以点透。'
            )
          ),
          Divider(),
          Listener(
            child: AbsorbPointer(
            // child: Container(  // => 1
              child: Container(
                height: 150,
                child: Listener(
                  child: IgnorePointer( // 这里不使用 IgnorePointer 也是可以的，因为本身AbsorbPointer就会忽略内部的point事件
                      child: Center(child: Text("内部Listener永远不会触发")),
                  ),
                  onPointerDown: (e) {
                    print(
                      '该行永远不会打印出来'
                    );
                  },
                ),
              ),
            ),
            // behavior: HitTestBehavior.opaque, // => 2
            onPointerDown: (event) => print(
              'IgnorePointer 和 AbsorbPointer 都会忽略PointEvent，区别在于前者本身也会忽略，后者本身不会忽略\n'
              'AbsorbPointer 本身不但不会忽略，还自带HitTestBehavior.opaque效果\n'
              'IgnorePointer 不仅会忽略事件，而且当behavior 为默认值时，IgnorePointer 也不会冒泡，感觉就像这个widget是透明的一样'
              '可以切换上面 =>1, =>2 看效果'
            )
          ),
          Divider(),
        ],
      ),
    );
  }
}

