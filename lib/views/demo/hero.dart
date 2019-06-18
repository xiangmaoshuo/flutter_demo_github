import 'package:flutter/material.dart';

class _HeroDemo extends StatelessWidget {
  _HeroDemo({
    Key key,
    @required this.tag,
    @required this.image
  }): assert(tag != null),
      super(key: key);

  /// 图片
  final Image image;

  /// hero动画唯一标识
  final Object tag;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Hero(
      tag: tag,
      child: Material(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.only(top: mq.padding.top),
          child: Image(image: image.image, fit: BoxFit.fitWidth, width: mq.size.width, height: mq.size.height,),
        ),
      ),
    );
  }
}

typedef _TransitionBuilderFn = Widget Function(BuildContext, Animation<double>, Animation<double>, Widget);

class HeroPage extends StatelessWidget {
  static Duration duration = Duration(milliseconds: 300);
  static _TransitionBuilderFn transitionsBuilder = (context, animation, animation2, child) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  };
  static open (BuildContext context, Image image, Object tag) {
    Navigator.push(context, PageRouteBuilder(
      transitionDuration: duration,
      transitionsBuilder: transitionsBuilder,
      pageBuilder: (context, animation, animation2) => _HeroDemo(image: image, tag: tag)
    ));
  }

  HeroPage({
    Key key,
    @required this.tag,
    @required this.child,
  }) : assert(tag != null),
       assert(child != null),
       super(key: key);

  /// 需要执行hero动画的子widget
  final Image child;

  /// hero动画需要的tag
  final Object tag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
        tag: tag,
        child: child,
      ),
      onTap: () => open(context, child, tag),
    );
  }
}
