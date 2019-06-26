import 'package:flutter/material.dart';
import 'package:flutter_demo/bloc/index.dart' show BlocListener;
import 'placeholder_image.dart' show PlaceHolderImageDemo, PlaceHolderCallbackType, PlaceHolderImageStatus;
import 'package:flutter_demo/bloc/index.dart' show StateDispatchBloc, BlocBuilder;

class _ScaleWidgetDemoBloc extends StateDispatchBloc<_ScaleWidgetDemoType> {
  _ScaleWidgetDemoBloc() : super(_ScaleWidgetDemoType(origin: Offset(0, 0), scale: 1.0));
}

class _ScaleWidgetDemoType {
  _ScaleWidgetDemoType({
    this.scale,
    this.origin
  });
  final double scale;
  final Offset origin;
}

/// 传入一个图片生成对象[ImageProvider]，可以让用户对该图片进行缩放
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
  /// 当前缩放比例
  double _scale = 1.0;

  /// 在拖拽时，每次基于该值进行增加/减少，最终的值才是[_scale]
  double _baseScale = 1.0;

  /// 传入图片的宽度
  double _width;

  /// 传入图片的高度
  double _height;

  /// 当前视口的宽度
  double _viewWidth;

  /// 当前视口的高度
  double _viewHeight;

  /// 缩放时的原点
  Offset _origin;

  /// 上次的中心点，该值用在当图片被放大后，单指滑动以确定中心点
  Offset _beforeOrigin;

  /// 双击缩放的动画控制器
  AnimationController _controller;

  /// 屏幕像素比
  double _devicePixelRatio;

  /// 图片是否加载成功
  bool _loadOk = false;

  /// 最大缩放比例
  double _maxScale;

  /// 最小缩放比例
  double _mainScale = .5;

  /// 图片刚加载完成时，被[Image]组件的[BoxFit.contain]缩放的比例
  double _ratio;

  /// 用于scale和orign的更新
  final _ScaleWidgetDemoBloc _bloc = _ScaleWidgetDemoBloc();

  /// 图片加载成功回调，在这里获取图片宽度和高度
  _successCallback (BuildContext _, PlaceHolderCallbackType state) {
    _loadOk = state.status == PlaceHolderImageStatus.success;
    if (_loadOk) {
      _width = state.imgInfo.image.width / _devicePixelRatio;
      _height = state.imgInfo.image.height / _devicePixelRatio;
      _ratio = _width > _height ? _width / _viewWidth : _height / _viewHeight;
      _maxScale = (_ratio < 1 ? _devicePixelRatio : _devicePixelRatio + _ratio) + 1;
      _controller?.dispose();
      _controller = AnimationController(
        lowerBound: _mainScale,
        upperBound: _maxScale,
        duration: Duration(milliseconds: 200),
        vsync: this
      )..addListener(() {
        final v = _controller.value;
        if (v == _scale) return;
        _scale = v;
        _bloc.dispatch(_ScaleWidgetDemoType(origin: _origin, scale: v));
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mq = MediaQuery.of(context);
    _devicePixelRatio = mq.devicePixelRatio;
    final _size = mq.size;
    _viewWidth = _size.width;
    _viewHeight = _size.height - mq.padding.top;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = PlaceHolderImageDemo(
      image: widget.image,
      hero: false,
      fit: BoxFit.scaleDown,
    );
    final child = BlocListener(
      bloc: image.bloc,
      child: image,
      listener: _successCallback,
    );
    return GestureDetector(
      child: BlocBuilder(
        bloc: _bloc,
        builder: (context, _ScaleWidgetDemoType state) {
          return Transform.scale(
            child: child,
            scale: state.scale,
            // 原点是相对于左上角的
            origin: state.origin,
            /// 这里的对齐方式要和上面的origin保持同样的参考标准，都是左上角，这样才能保证视口的位置为当前缩放的位置
            alignment: Alignment.topLeft,
          );
        },
      ),
      onScaleUpdate: (details) {
        final origin = details.focalPoint;
        // 单指滑动逻辑
        if (details.rotation == 0.0) {
          // 放大状态表现为图片的细节查看
          if (_scale > 1.0) {
            _origin = _beforeOrigin == null ? _origin : _origin - (origin - _beforeOrigin);
            _beforeOrigin = origin;
          } else {
            // 切换图片逻辑
          }
          
        } else {
          // 缩放逻辑
          _scale = _baseScale + details.scale - 1;
          if (_scale < _mainScale) _scale = _mainScale;
          if (_scale > _maxScale) _scale = _maxScale;
          _origin = origin;
        }
        _bloc.dispatch(_ScaleWidgetDemoType(origin: _origin, scale: _scale));
      },
      onScaleEnd: (_) {
        // 结束时需要清空上次定位
        _beforeOrigin = null;
        // 超过最大时回滚到最大
        if (_scale > _maxScale - 1) {
          _controller.value = _scale;
          _scale = _maxScale - 1;
          _controller.animateTo(_scale);
        }
        // 赋值，用于下次使用
        _baseScale = _scale;
      },
      onDoubleTap: () {
        double scale = _scale;
        double maxScale = _maxScale - 1;
        // 如果当前缩放比例小于1或者为最大时，scale复原
        if (_scale < 1.0 || _scale == maxScale) scale = 1.0;
        // 反之，如果当前缩放比例大于或等于1，则每次放大scale的一半
        else if (_scale >= 1.0 && _scale < maxScale) scale += 1;
        if (scale > maxScale) scale = maxScale;
        _controller.value = _scale;
        _scale = scale;
        _controller.animateTo(scale);
        // 赋值，用于下次使用
        _baseScale = _scale;
      },
    );
  }
}
