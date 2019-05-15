import 'package:flutter/material.dart';

class AnimationDemo extends StatefulWidget {
  @override
  State<AnimationDemo> createState() {
    return new _AnimationDemoState();
  }
}

class _AnimationDemoState extends State<AnimationDemo> with TickerProviderStateMixin {
  Animation<double> animation;
  Animation<double> animation2;
  Animation<double> animation3;
  AnimationController controller;
  AnimationController controller2;
  int type = 0;
  @override
  void initState() {
    super.initState();

    /*
      controller 控制动画的执行，反转等
      animation 是表示这个动画怎么执行的，生成动画可以通过Tween的animate方法得到
      几个概念：tween(动画值的变化过程),controller（动画的控制器，以及持续时间等设置）,curve（动画变化的方式是怎样的）,ticker（帧回调处理）
     */
    controller = new AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this
    );
    // 这里为什么要用点点来调用addListener? 因为..调用返回的还是Animation 类型给 变量 animation
    animation = new Tween(begin: 1.0, end: 100.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOutSine))..addListener(() {
      setState(() {
      });
    });

    // animation2 没有设置监听，而是通过animatedBuilder widget 内部设置监听，这样更新动画时就只会更新局部，有利于性能提升
    animation2 = new Tween(begin: 1.0, end: 100.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller2 = new AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this
    );
    // 该动画会一直执行
    animation3 = new Tween(begin: 1.0, end: 100.0).animate(controller2)..addStatusListener((status) {
      if (status == AnimationStatus.dismissed) controller2.forward();
      else if (status == AnimationStatus.completed) controller2.reverse();
    });
    controller2.forward();
  }

  @override
  void dispose() {
    controller2.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 340,
            child: Padding(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                children: <Widget>[
                  Text('${animation.value.toStringAsFixed(2)}'),
                  AnimatedBuilder(
                    animation: animation2,
                    // 不能这样写，这样会导致每次builder返回的都是同一个child，除非父级widget更新，不然虽然动画的值一直在变，但是child却一直没变
                    // 因为触发更新的是子widget，child的值是受父元素影响的
                    // child: Text('${animation2.value.toStringAsFixed(2)}'),
                    builder: (context, child) {
                      return Text('${animation2.value.toStringAsFixed(2)}');
                    },
                  ),
                  AnimatedBuilder(
                    animation: animation3,
                    builder: (context, child) {
                      return Text('${animation3.value.toStringAsFixed(2)}');
                    },
                  ),
                  RaisedButton(
                    child: Text(type == 0 ? 'start!' : 'reverse!'),
                    onPressed: () {
                      type == 0 ? controller.forward() : controller.reverse();
                      type = type == 0 ? 1 : 0;
                    },
                  ),
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}
