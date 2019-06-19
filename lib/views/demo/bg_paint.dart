import 'package:flutter/material.dart';

/// 绘制指定颜色的背景
class BgPaint extends StatelessWidget {
  BgPaint({
    this.color = Colors.white,
    @required this.child,
  }): assert(child != null),
      super();

  /// 要将背景绘制成什么颜色
  final Color color;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BgPainer(color),
      child: child,
    );
  }
}

class _BgPainer extends CustomPainter {
  _BgPainer(this.color) : super();

  /// 要将背景绘制成什么颜色
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景
    Paint paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..color = color;
    canvas.drawRect(Offset.zero & size, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
