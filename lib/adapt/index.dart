import 'package:flutter/material.dart';

/// 针对[Adapt]提供的用于获取屏幕相关信息的[Widget]，一般在项目入口使用一次该组件，
/// 后续即可在项目的任何地方通过[Adapt()]来获取到屏幕信息，以及移动端适配方法
class AdaptBuilder extends StatelessWidget {
  const AdaptBuilder({
    Key key,
    @required this.child,
  }) : assert(child != null),
       super(key: key);

  /// 子类，必填
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    Adapt._init(context: context);
    return child;
  }
}

/// 用于适配不同移动端设备的类
/// 在准备适配或者访问屏幕信息时，使用[Adapt()]获取到[Adapt]全局单例即可
/// 初始化请使用[AdaptBuilder]组件
class Adapt {
  Adapt._({
    @required double uiWidth,
    @required double uiHeight,
    @required BuildContext context,
  }): this.uiWidth = uiWidth,
      this.uiHeight = uiHeight,
      this._context = context
      {
        final _mediaQuery = MediaQuery.of(_context);
        this._width = _mediaQuery.size.width;
        this._height = _mediaQuery.size.height;
        this._paddingTop = _mediaQuery.padding.top;
        this._paddingBottom = _mediaQuery.padding.bottom;
        this._pixelRatio = _mediaQuery.devicePixelRatio;
        this._ratioW = _width / this.uiWidth;
        this._ratioH = _height / this.uiHeight;
      }

  /// 单例
  static Adapt get instance => _instance;
  static Adapt _instance;

  /// 访问数据时使用该工厂函数
  factory Adapt() => _instance;

  /// 初始化获取屏幕信息时使用该工厂函数
  factory Adapt._init({
    BuildContext context,
    double uiWidth = 750.0,
    double uiHeight = 1334.0
  }) {
    assert(() {
      if (_instance == null) {
        if (context != null) return true;

        throw FlutterError('Adapt: the context can`t be null when _instance is null');
      } else {
        if (context == null) return true;
        if (context != _instance._context) throw FlutterError('Adapt: already has context, you should`t want change it!');
        return true;
      }
    }());
    if ((_instance == null) || (context == _instance._context)) {
      _instance = Adapt._(uiWidth: uiWidth, uiHeight: uiHeight, context: context);
    }
    return _instance;
  }
  
  /// 上下文对象，只有上下文对象没有改变时，才能更新单例
  final BuildContext _context;

  /// ui设计图是的宽度
  final double uiWidth;

  /// ui设计图的高度
  final double uiHeight;

  /// 屏幕宽度和ui设计图的宽度比
  double get ratioW => _ratioW;
  double _ratioW;

  /// 屏幕高度和ui设计图的高度比
  double get ratioH => _ratioH;
  double _ratioH;

  /// 屏幕宽度
  double get width => _width;
  double _width;

  /// 屏幕高度
  double get height => _height;
  double _height;

  /// 屏幕顶部填充的高度
  double get paddingTop => _paddingTop;
  double _paddingTop;

  /// 屏幕底部填充的高度
  double get paddingBottom => _paddingBottom;
  double _paddingBottom;

  /// 屏幕像素比
  double get pixelRatio => _pixelRatio;
  double _pixelRatio;

  /// 宽度适配
  double scale(double number) {
      return number * ratioW;
  }

  /// 高度适配，一般在首屏效果时使用
  double scaleH(double number) {
      return number * ratioH;
  }

  /// 1px 效果
  double one() {
      return 1 / pixelRatio;
  }
  String toString() => 'uiWidth: $uiWidth, uiHeight: $uiHeight, ratioW: $ratioW, ratioH: $ratioH, '
  'width: $width, height: $height, paddingTop: $paddingTop, paddingBottom: $paddingBottom, pixelRatio: $pixelRatio';
}
