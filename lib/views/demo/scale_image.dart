import 'dart:math' show max;
import 'package:flutter/material.dart';
import 'package:flutter_demo/bloc/index.dart' show BlocListener;
import 'placeholder_image.dart' show PlaceHolderImageDemo, PlaceHolderCallbackType, PlaceHolderImageStatus;
import 'package:flutter_demo/bloc/index.dart' show StateDispatchBloc, BlocBuilder;
import 'package:flutter_demo/adapt/index.dart' show Adapt;

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

/*
 * 原理梳理：
 *  1.缩放： 
 *    a. 通过监听[onScaleUpdate] 来实现的；该事件的事件对象中的scale是表示从双手放上开始，期间所产生的缩放量，所以这里需要知道在第一次触发该事件时图片本身的缩放量，
 *       在本实例中即[_baseScale]，该值会在每次缩放结束进行保存。
 *    b. 通过双击来实现，这个比较简单，只是需要注意一些变量的保存，如[_baseScale, _beforeOrigin]；最后通过动画过渡到目标scale大小
 *  2.滑动查看：
 *    当放大时，我们可以左右滑动来查看图片不同位置的细节，这个其实是通过修改缩放组件的[origin]来实现的；[origin]是相对于该renderObject的左上角的一个[Offset]类实例，
 *    并且由于缩放并不会影响布局，加之我们本身组件使用的fit是[BoxFit.scaleDown]，这样一来，这个[origin]实际上几乎是相对于屏幕的位置了(这里要除去顶部padding占据的位置)，
 *    所以我们每次缩放时，不能直接使用该值，因为这样会导致定位不准，我们应该只对[origin]赋值一次，在它为null的时候，然后后续的移动我们就在该值上进行相对增减即可；值得注意
 *    的是，缩放组件默认对其是居中对齐的，为了方便起见，我们需要设置其对其方式为居左上角对齐，和origin保持一致，这样计算起来会方便一些。
 */

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

class _ScaleWidgetDemoState extends State<ScaleWidgetDemo> with TickerProviderStateMixin {
  /// 当前缩放比例
  double _scale = 1.0;

  /// 在拖拽时，每次基于该值进行增加/减少，最终的值才是[_scale]
  double _baseScale = 1.0;

  /// 传入图片的宽度
  double _width;

  /// 传入图片的高度
  double _height;

  /// 当前视口的宽度
  double _viewWidth = Adapt().width;

  /// 当前视口的高度
  double _viewHeight = Adapt().height - Adapt().paddingTop;

  /// 初始宽度，即在没有缩放的情况下，图片经过[BoxFit.scaleDown]后所展示的宽度
  double _baseWidth;

  /// 初始高度，意义同初始宽度
  double _baseHeight;

  /// 缩放时的原点
  Offset _origin;

  /// 上次的中心点，该值用在当图片被放大后，单指滑动以确定中心点
  Offset _beforeOrigin;

  /// 双击缩放的动画控制器
  AnimationController _scaleController;

  /// 用于[_origin]复位的动画控制器
  AnimationController _originController;

  /// 用于[_origin]复位的动画控制器 对应的动画[Tween]
  Tween<Offset> _originTween;

  /// 滑动惯性动画
  Tween<Offset> _moveTween;

  /// 图片是否加载成功
  bool _loadOk = false;

  /// 最大缩放比例
  double _maxScale;

  /// 最小缩放比例
  double _mainScale = .5;

  /// 图片的中心，在特定的时刻会将该值赋给[_origin]
  Offset _centerOffset;

  /// 用于scale和orign的更新
  final _ScaleWidgetDemoBloc _bloc = _ScaleWidgetDemoBloc();

  /// 图片加载成功回调，在这里获取图片宽度和高度
  _successCallback (BuildContext _, PlaceHolderCallbackType state) {
    _loadOk = state.status == PlaceHolderImageStatus.success;
    if (_loadOk) {

      final imgSelfScale = state.imgInfo.scale;
      _width = state.imgInfo.image.width / imgSelfScale;
      _height = state.imgInfo.image.height / imgSelfScale;

      // 获取图片屏下宽高和视口宽高分别的对应的比例
      final ratioW = _width / _viewWidth;
      final ratioH = _height / _viewHeight;

      // BoxFit.contain的规则是以比例大的那一个为准
      /// 图片刚加载完成时，被[Image]组件的[BoxFit.contain]缩放的比例
      final _ratio = max(ratioW, ratioH);

      if (_ratio == ratioW) {
        _baseWidth = _ratio < 1 ? _width : _viewWidth;
        _baseHeight = _baseWidth / _width * _height;
      } else {
        _baseHeight = _ratio < 1 ? _height : _viewHeight;
        _baseWidth = _baseHeight / _height * _width;
      }

      _maxScale = (_ratio < 1 ? imgSelfScale : imgSelfScale + _ratio) + 1;
      _centerOffset = Offset(_viewWidth / 2, _viewHeight / 2);
      _scaleController?.dispose();
      _scaleController = AnimationController(
        lowerBound: _mainScale,
        upperBound: _maxScale,
        duration: Duration(milliseconds: 200),
        vsync: this
      )..addListener(() {
        final v = _scaleController.value;
        if (v == _scale) return;
        _scale = v;
        _origin ??= _centerOffset;
        _bloc.dispatch(_ScaleWidgetDemoType(origin: _origin, scale: v));
      });
    }
  }

  /// 对传入的[sourceOrigin]进行判断，如果符合要求则使用其自身的值，否则使用[reserveOrigin]对应的值
  /// [number]用于在拖动时，允许的超出长度，该值会在[onScaleEnd]事件中用来做恢复动画
  Offset _getOrigin (Offset sourceOrigin, { Offset reserveOrigin, double number = 50.0 }) {
    // 水平方向和垂直方向分别的最小偏移量
    final minHorizontalOffset = (_viewWidth - _baseWidth) / 2 * _scale - number;
    final minVerticalOffset = (_viewHeight - _baseHeight) / 2 * _scale - number;
    
    final _dividendScale = _scale - 1;

    /// 最小偏移量在当前缩放倍数下的[_origin]坐标值
    final leftDx = minHorizontalOffset / _dividendScale;
    final rightDx = _viewWidth - leftDx;
    final topDx = minVerticalOffset / _dividendScale;
    final bottomDx =_viewHeight - topDx;

    final dx = sourceOrigin.dx;
    final dy = sourceOrigin.dy;
    // 算出当前图片所处的origin下的上下左右的偏移量
    final topOffset = dy * (_scale - 1);
    final bottomOffset = (_viewHeight - dy) * (_scale - 1);
    final leftOffset = dx * (_scale - 1);
    final rightOffset = (_viewWidth - dx) * (_scale - 1);

    // 只有当4个偏移值都大于各自方向上的最小偏移值，本次偏移才算有效
    final leftBool = leftOffset >= minHorizontalOffset;
    final rightBool = rightOffset >= minHorizontalOffset;
    final topBool = topOffset > minVerticalOffset;
    final bottomBool = bottomOffset >= minVerticalOffset;
    final horizontalBool = _baseWidth * _scale <= _viewWidth;
    final verticalBool = _baseHeight * _scale <= _viewHeight;
    return Offset(
      horizontalBool ? _centerOffset.dx : (leftBool && rightBool) ? sourceOrigin.dx : reserveOrigin?.dx ?? (leftBool ? rightDx : leftDx),
      verticalBool ? _centerOffset.dy : (topBool && bottomBool) ? sourceOrigin.dy : reserveOrigin?.dy ?? (topBool ? bottomDx : topDx)
    );
  }

  @override
  void initState() {
    super.initState();
    _originController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _originTween = new Tween<Offset>();
    _moveTween = new Tween<Offset>();
  
    final Animation<Offset> moveAnimation = _moveTween
      .animate(CurvedAnimation(parent: _originController, curve: Interval(0.0, 0.5, curve: Curves.easeOut)));

    moveAnimation.addListener(() {
      if (_originController.value > 0.5) return;
      if (moveAnimation.value == _origin) return;
      if (_moveTween.begin == _moveTween.end) return;
      _origin = moveAnimation.value;
      _bloc.dispatch(_ScaleWidgetDemoType(origin: moveAnimation.value, scale: _scale));
    });

    final Animation<Offset> originAnimation = _originTween
      .animate(CurvedAnimation(parent: _originController, curve: Interval(0.5, 1.0, curve: Curves.easeOut)));

    originAnimation.addListener(() {
      if (_originController.value <= 0.5) return;
      if (originAnimation.value == _origin) return;
      if (_originTween.begin == _originTween.end) return;
      _origin = originAnimation.value;
      _bloc.dispatch(_ScaleWidgetDemoType(origin: originAnimation.value, scale: _scale));
    });
  }

  @override
  void dispose() {
    _scaleController?.dispose();
    _originController?.dispose();
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
            final targetOrign = _beforeOrigin == null ? _origin : _origin - (origin - _beforeOrigin);
            _origin = _getOrigin(targetOrign, reserveOrigin : _origin);
            _beforeOrigin = origin;
          } else {
            // 切换图片逻辑
          }
          
        } else {
          // 缩放逻辑
          _scale = _baseScale + details.scale - 1;
          if (_scale < _mainScale) _scale = _mainScale;
          if (_scale > _maxScale) _scale = _maxScale;
          _origin = _scale <= 1.0 ? _centerOffset : _origin ?? origin;
        }
        _bloc.dispatch(_ScaleWidgetDemoType(origin: _origin, scale: _scale));
      },
      onScaleEnd: (details) {

        // 超过最大时回滚到最大
        if (_scale > _maxScale - 1) {
          _scaleController.value = _scale;
          _scale = _maxScale - 1;
          _scaleController.animateTo(_scale);
        }
        // 赋值，用于下次使用
        _baseScale = _scale;

        // 结束时需要清空上次定位
        _beforeOrigin = null;
        
        // 当没有放大时，图片位置是始终居中的，所以惯性/复位动画不适用
        if (_scale <= 1) return;

        // 惯性动画
        _moveTween.begin = _origin;
        _moveTween.end = _getOrigin(_origin - (details.velocity.pixelsPerSecond / _scale * 0.2));

        // 复位动画
        _originTween.begin = _moveTween.end;
        _originTween.end = _getOrigin(_moveTween.end, number: 0.0);
        _originController.value = 0.0;
        _originController.forward();
      },
      onDoubleTap: () {
        double scale = _scale;
        double maxScale = _maxScale - 1;
        // 如果当前缩放比例小于1或者为最大时，scale复原
        if (_scale < 1.0 || _scale == maxScale) scale = 1.0;
        // 反之，如果当前缩放比例大于或等于1，则每次放大scale的一半
        else if (_scale >= 1.0 && _scale < maxScale) scale += 1;
        if (scale > maxScale) scale = maxScale;
        _scaleController.value = _scale;
        _scale = scale;
        _scaleController.animateTo(scale);
        // 赋值，用于下次使用
        _baseScale = _scale;
      },
    );
  }
}
