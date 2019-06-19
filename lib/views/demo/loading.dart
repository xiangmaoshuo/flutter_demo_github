import 'package:flutter/material.dart';

typedef Widget LoadingItemBuilder(BuildContext context, Widget child, Animation<double> animation);

final LoadingItemBuilder _defaultLoadingItemBuilder = (context, child, animation) {
  return ScaleTransition(
    child: child,
    scale: animation,
  );
};

/// 该widget是传入一个[loadingText]后，然后一个字一个字的将[loadingText]的内容展示出来；
/// [milliseconds]表示每个字展示出来需要的时间，所以总共的时间默认是[milliseconds]乘以[loadingText]的长度；
/// 为了达到不同的效果，还提供了[speed]参数，因为在上述的默认效果中，每个字从无到有的展示所需要的时间和每个字的加载时间是相等的；
/// [speed]的值为0 ~ 1，默认为1，当它小于1时，意味着每个字的加载速度比每个字完全展示出来的速度要快，这样就达到了不同的效果
class LoadingDemo extends StatefulWidget {
  const LoadingDemo({
    Key key,
    this.loadingText = 'loading...',
    this.milliseconds = 300,
    this.speed = 1,
    this.itemBuilder,
  }) : assert(speed > 0.0 && speed <= 1.0),
    super(key: key);
  /// 文本内容
  final String loadingText;
  /// 每个字的动画展示时间；[milliseconds] * [speed] 是每个字加载的间隔时间
  final int milliseconds;
  /// [milliseconds] * [speed] 是每个字加载的间隔时间
  final double speed;
  final LoadingItemBuilder itemBuilder;

  @override
  State<LoadingDemo> createState() {
    return new _LoadingDemoState();
  }
}

class _LoadingDemoState extends State<LoadingDemo> with TickerProviderStateMixin {
  List<String> _children = [];
  Duration _itemDuration;
  AnimationController _controller;
  Animation<double> _animation;
  List<String> _textList;
  LoadingItemBuilder _itemBuilder;
  int _currentValue = -1;

  // animation listener
  _listenerFn () {
    final len = _textList.length;
    int v = _animation.value.round();
    if (_currentValue == v) return; // 避免重复渲染
    _currentValue = v;

    // 重新渲染
    setState(() {
      _children = _textList.sublist(0, v);
    });
  }

  // animation status listener
  _listenerStatusFn (AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // 等最后一个文字的渲染动画执行完成后再进入下一个循环
      Future.delayed(_itemDuration).then((_) {
        if (this.mounted) {
          _controller.reset();
          _controller.forward();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _itemBuilder = widget.itemBuilder;
    _itemDuration = Duration(milliseconds: widget.milliseconds);
    _textList = widget.loadingText.split('');
    final len = _textList.length;
    _controller = AnimationController(
      vsync: this,
      duration: _itemDuration * len * widget.speed
    );

    _animation = Tween(begin: 0.0, end: len.toDouble())
      .animate(CurvedAnimation(parent: _controller, curve: Curves.linear))
      ..addListener(_listenerFn)
      ..addStatusListener(_listenerStatusFn);
    _controller.forward();
  }

  @override
  void dispose() {
    _animation.removeListener(_listenerFn);
    _animation.removeStatusListener(_listenerStatusFn);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _children.map<Widget>((item) => _Loadingitem(item, _itemDuration, _itemBuilder)).toList(),
    );
  }
}

/// loading Widget的每个子元素的渲染方式，[_text]即文本，[_duration]持续时间，[_itemBuilder]自定义渲染方法
class _Loadingitem extends StatefulWidget {
  _Loadingitem(this._text, this._duration, this._builder);

  final String _text;
  final Duration _duration;
  final LoadingItemBuilder _builder;
  @override
  State<_Loadingitem> createState() {
    return new _LoadingitemState();
  }
}

class _LoadingitemState extends State<_Loadingitem> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  LoadingItemBuilder _builder;
  @override
  void initState() {
    super.initState();
    _builder = widget._builder ?? _defaultLoadingItemBuilder;
    _controller = new AnimationController(vsync: this, duration: widget._duration );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return _builder(context, Text(widget._text), _controller);
  }
}




