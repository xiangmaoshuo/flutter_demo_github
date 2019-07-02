import 'package:flutter/material.dart';

/// 用于适配不同移动端设备的类
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

  /// 工厂函数
  factory Adapt(BuildContext context, {
    double uiWidth = 750.0,
    double uiHeight = 1334.0
  }) {
    assert(_instance == null ? context != null : true);
    if ((_instance == null) || (context == _instance._context)) {
      _instance = Adapt._(uiWidth: uiWidth, uiHeight: uiHeight, context: context);
    }
    return _instance;
  }
  
  double _width;
  double _height;
  double _paddingTop;
  double _paddingBottom;
  double _pixelRatio;
  double _ratioW;
  double _ratioH;

  /// 上下文对象，只有上下文对象没有改变时，才能更新单例
  final BuildContext _context;

  /// ui设计图是的宽度
  final double uiWidth;

  /// ui设计图的高度
  final double uiHeight;

  /// 屏幕宽度和ui设计图的宽度比
  double get ratioW => _ratioW;

  /// 屏幕高度和ui设计图的高度比
  double get ratioH => _ratioH;

  /// 屏幕宽度
  double get width => _width;

  /// 屏幕高度
  double get height => _height;


  /// 屏幕顶部填充的高度
  double get paddingTop => _paddingTop;

  /// 屏幕底部填充的高度
  double get paddingBottom => _paddingBottom;

  /// 屏幕像素比
  double get pixelRatio => _pixelRatio;

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
