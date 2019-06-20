import 'package:flutter/material.dart';
import 'dart:math' show max;

import 'placeholder_image.dart' show PlaceHolderImageDemo;

/// 传入一个图片生成对象，可以让用户对该图片进行缩放
class ScaleWidgetDemo extends StatefulWidget {
  ScaleWidgetDemo({
    this.image,
  });

  /// 需要缩放的图片
  final ImageProvider image;

  @override
  State<ScaleWidgetDemo> createState() {
    return new _ScaleWidgetDemoState();
  }
}

class _ScaleWidgetDemoState extends State<ScaleWidgetDemo> with SingleTickerProviderStateMixin {
  /// 初始缩放比例
  double _scale = 1.0;

  /// 传入图片的宽度
  double _width;

  /// 传入图片的高度
  double _height;

  /// 缩放时的原点
  Offset _origin;

  /// 双击缩放的动画控制器
  AnimationController _controller;

  /// 屏幕像素比
  double _devicePixelRatio;

  /// 图片加载成功回调，在这里获取图片宽度和高度
  _successCallback (bool _, ImageInfo imageInfo, bool __) {
    _width = imageInfo.image.width / _devicePixelRatio;
    _height = imageInfo.image.height / _devicePixelRatio;
    final mq = MediaQuery.of(context);
    final _size = mq.size;
    final sw = _size.width;
    final sh = _size.height - mq.padding.top;
    double maxScale = _width > _height ? _width / sw : _height / sh;
    print('maxScale:$maxScale');
  }

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   lowerBound: .5,
    //   upperBound: 3.0,
    //   value: _scale,
    //   duration: Duration(milliseconds: 200),
    //   vsync: this
    // );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
  }

  @override
  void didUpdateWidget(ScaleWidgetDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    // _size = context.size;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Transform.scale(
        child: PlaceHolderImageDemo(
          image: widget.image,
          successHandler: _successCallback,
          hero: false,
        ),
        scale: _scale,
        // 原点是相对于左上角的
        origin: _origin,
        /// 这里的对齐方式要和上面的origin保持同样的参考标准，都是左上角，这样才能保证视口的位置为当前缩放的位置
        alignment: Alignment.topLeft,
      ),
      onScaleUpdate: (details) {
        setState(() {
          _scale = details.scale;
          _origin = details.focalPoint;
        });
      },
    );
  }
}
