import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;

// 无论是 MaterialPageRoute, CupertinoPageRoute, PageRouteBuilder 都是继承自 PageRoute，如果这三者都不能满足需求，则可以考虑自己继承PageRoute，然后实现相关功能
class RouteDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: () async {
            final res = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _NextRoute())
            );
            if(res != null) Scaffold.of(context).showSnackBar(SnackBar(content: Text(res),));
          },
          child: Text('跳转到下个路由', style: TextStyle(color: Colors.white),),
        ),
        RaisedButton(
          child: Text('自定义动画跳转'),
          onPressed: () {
            Navigator.push(context, PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 200),
              transitionsBuilder: (context, animation, animation2, widget) {
                return ScaleTransition(
                  child: widget,
                  scale: CurvedAnimation(parent: animation, curve: Curves.easeIn),
                );
              },
              pageBuilder: (context, animation, animation2) {
                return FadeTransition(
                  child: _NextRoute(),
                  opacity: animation,
                );
              }
            ));
          },
        ),
        RaisedButton(
          child: Text('类似drawer的路由跳转'),
          onPressed: () {
            Navigator.push(context, PageRouteBuilder(
              opaque: false, // 设置背景为透明，这种情况不会释放当前路由背后的路由，所以也就不会重新render
              barrierColor: Colors.black45, // 遮罩层颜色，一般带有透明度
              barrierDismissible: true, // 点击遮罩层能否关闭该路由
              // 这里配置怎样过渡
              transitionsBuilder: (_, animation, __, child) {
                final _animation = Tween(begin: -MediaQuery.of(context).size.width, end: 0).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
                return Transform.translate(
                  offset: Offset(_animation.value.toDouble(), 0),
                  child: child,
                );
              },
              // 一般这里就只是配置最终页面长啥样
              pageBuilder: (_, animation, __) {
                return _ModalDemo();
              },
            ));
          },
        ),
        RaisedButton(
          child: Text('交错动画路由跳转'),
          onPressed: () {
            Navigator.push(context, PageRouteBuilder(
              opaque: false, // 设置背景为透明，这种情况不会释放当前路由背后的路由，所以也就不会重新render
              barrierColor: Colors.black45, // 遮罩层颜色，一般带有透明度
              barrierDismissible: true,
              transitionDuration: Duration(milliseconds: 600),
              pageBuilder: (_, animation, __) {
                return _ModalDemo();
              },
              transitionsBuilder: (_, animation, __, child) {
                final width = MediaQuery.of(context).size.width.toDouble();

                final animation1 = Tween(begin: -width, end: -width * .3).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Interval(0.0, 0.33,), // 通过Interval将动画分为几个阶段
                  )
                );
                final animation2 = Tween(begin: 0, end: - width * .2).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Interval(0.33, 0.66,),
                  )
                );
                final animation3 = Tween(begin: 0, end: width * .5).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Interval(0.66, 1.0,),
                  )
                );
                return Transform.translate(
                  offset: Offset(animation3.value.toDouble(), 0),
                  child: Transform.translate(
                    offset: Offset(animation2.value.toDouble(), 0),
                    child: Transform.translate(
                      offset: Offset(animation1.value.toDouble(), 0),
                      child: child,
                    ),
                  ),
                );
              }
            ));
          },
        ),
        RaisedButton(
          child: Text('IOS风格路由跳转'),
          onPressed: () {
            Navigator.push(context, CupertinoPageRoute(
              builder: (context) => _NextRoute()
            ));
          },
        ),
      ],
    );
  }
}

// 模拟了一个Drawer
class _ModalDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return UnconstrainedBox(
      alignment: Alignment.topLeft,
      child: Container(
        width: size.width * .83,
        height: size.height,
        color: Colors.white,
        child: Material(
          child: Center(
            child: ClipOval(
              child: Image.asset('lib/images/launch_background.png',width: 40, height: 40, fit: BoxFit.fitWidth,),
            ),
          ),
        ),
      ),
    );
  }
}


class _NextRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context, '来自_NextRoute widget 的信息');
          },
          child: Text('点我返回上个页面，并传递参数')
        )
      ),
      appBar: AppBar(
        title: Text('路由传参demo页面'),
      ),
    );
  }
}

