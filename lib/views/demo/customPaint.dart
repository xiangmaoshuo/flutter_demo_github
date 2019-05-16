import 'package:flutter/material.dart';
import 'dart:math';

class CustomPaintDemo extends StatelessWidget {
  final Size _size = Size(300, 300);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        painter: _BgPainer(_size),
        child: RepaintBoundary(
          child: Center(
            child: _PieceWidget(_size, size),
          ),
        ),
      ),
    );
  }
}

class _PieceWidget extends StatefulWidget {
  _PieceWidget(this.boxSize, this.screenSize);
  final Size boxSize; // 棋盘尺寸
  final Size screenSize; // 屏幕尺寸
  @override
  State<_PieceWidget> createState() {
    return new __PieceWidgetState();
  }
}

class __PieceWidgetState extends State<_PieceWidget> {
  List<Offset> list = [];

  // 获取点击位置对应的棋盘位置
  double _getPosition (num n, num pw) {
    return ((n % pw > pw / 2 ? (n / pw).floor() + 1 : (n / pw).floor()) * pw).toDouble();
  }
  
  @override
  Widget build(BuildContext context) {
    double diffx = (widget.screenSize.width - widget.boxSize.width) / 2;
    double diffy = (widget.screenSize.height - widget.boxSize.height) / 2;
    double pw = widget.boxSize.width / 15; // 棋盘间距
    return Listener(
      child: CustomPaint(
        size: widget.boxSize,
        painter: _PiecePainer(list: list),
      ),
      onPointerDown: (event) {
        final Offset offset = Offset(_getPosition(event.position.dx - diffx, pw), _getPosition(event.position.dy - diffy, pw));
        if (list.indexOf(offset) >= 0) return;
        setState(() {
          list.add(offset);
        });
      },
    );
  }
}


// 棋盘
class _BgPainer extends CustomPainter {
  _BgPainer(this.size) : super();

  final Size size;

  @override
  void paint(Canvas canvas, Size size) {
    final Size _size = this.size;
    final Offset startOffset = Offset((size.width - _size.width) / 2, (size.height - _size.height) / 2);
    // 绘制最外层背景（白色）
    Paint paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..color = Colors.white;
    canvas.drawRect(Offset.zero & size, paint);

    paint
    ..color = Color(0x77cdb175);
    canvas.drawRect(startOffset & _size, paint);

    paint
    ..style = PaintingStyle.stroke
    ..color = Colors.black87
    ..strokeWidth = 1.0;

    double eWidth = _size.width / 15;
    double eHeight = _size.height / 15;
    double sdx = startOffset.dx;
    double sdy = startOffset.dy;
    // 横
    for (int i = 0; i <= 15; i++) {
      double dy = eWidth * i + sdy;
      canvas.drawLine(Offset(sdx, dy), Offset(_size.width + sdx, dy), paint);
    }

    // 竖
    for (int i = 0; i <= 15; i++) {
      double dx = eHeight * i + sdx;
      canvas.drawLine(Offset(dx, sdy), Offset( dx, _size.height + sdy), paint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// 棋子
class _PiecePainer extends CustomPainter {
  _PiecePainer({ this.list = const [] }): super();
  final List<Offset> list;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
    ..style = PaintingStyle.fill;
    final white = Colors.white;
    final black = Colors.black;
    for(int i = 0; i < list.length; i++) {
      paint..color = i % 2 == 0 ? white : black;
      canvas.drawCircle(list[i], 7.5, paint);
    }
  }
  @override
  bool shouldRepaint(_PiecePainer oldDelegate) {
    return true;
  }
}
