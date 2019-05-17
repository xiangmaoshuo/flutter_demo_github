import 'package:flutter/material.dart';
import 'package:flutter_demo/tools/event_bus.dart';
import 'dart:math' as math;
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
            child: SizedBox(
              width: _size.width,
              height: _size.height,
              child: _PieceWidget(_size, size),
            ),
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

class __PieceWidgetState extends State<_PieceWidget> with SingleTickerProviderStateMixin {
  List<Offset> whiteList = [];
  List<Offset> blackList = [];
  bool isWhite = true;
  bool isWin = false;
  final _sortHandler = (Offset a, Offset b) => a.dx.compareTo(b.dx);
  final _conpareHandler = (Offset current, Offset lastItem) => current.dx - lastItem.dx;
  final _sortHandlerY = (Offset a, Offset b) => a.dy.compareTo(b.dy);
  final _conpareHandlerY = (Offset current, Offset lastItem) => current.dy - lastItem.dy;
  AnimationController _controller;
  // 统计旋转次数
  int rotateIndex = 0;
  // 盒子居中后，距离屏幕左侧的距离
  double get diffx => (widget.screenSize.width - widget.boxSize.width) / 2;

  // 盒子居中后，距离屏幕顶部的距离
  double get diffy => (widget.screenSize.height - widget.boxSize.height) / 2;

  // 格子之间的间距
  double get pw => widget.boxSize.width / 15;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      lowerBound: -double.infinity,
      upperBound: double.infinity,
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _controller.value = 0.0;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // 获取点击位置对应的棋盘位置
  double _getPosition (num n) {
    return ((n % pw > pw / 2 ? (n / pw).floor() + 1 : (n / pw).floor()) * pw).toDouble();
  }

  // 检查每个列，看看是否有5个连在一起的
  bool _checkList (List<Offset> list, sortHandler, compareHandler) {
    if (list.length > 4) {
      list.sort(sortHandler);
      final List<Offset> winList = [list[0]];
      final length = list.length;
      for (int j = 1; j < length; j++) {
        final current = list[j];
        final len = winList.length;
        if (compareHandler(current, winList[len - 1]) != pw) winList.removeRange(0, len);
        winList.add(current);
        if (winList.length == 5) return true; // 如果长度为5，则表示已经赢了
      }
    }
    return false;
  }

  // 检查谁赢了
  _checkWhoWin (Offset offset) {
    final List list = isWhite ? whiteList : blackList;
    final int length = list.length;
    List<Offset> horizontal = []; // 横
    List<Offset> vertical = []; // 竖
    List<Offset> leftOblique = []; // 撇
    List<Offset> rightOblique = []; //捺
    final dx = offset.dx;
    final dy = offset.dy;
    final increase = dx + dy;
    final reduce = dx - dy;
    for(int i = 0; i < length; i++) {
      final target = list[i];
      final tdx = target.dx;
      final tdy = target.dy;
      if (tdx == dx) vertical.add(target);
      if (tdy == dy) horizontal.add(target);
      if (tdx + tdy == increase) leftOblique.add(target);
      if (tdx - tdy == reduce) rightOblique.add(target);
    }
    
    isWin = _checkList(leftOblique, _sortHandler, _conpareHandler)
      || _checkList(rightOblique, _sortHandler, _conpareHandler)
      || _checkList(vertical, _sortHandlerY, _conpareHandlerY)
      || _checkList(horizontal, _sortHandler, _conpareHandler);
  }
  
  @override
  Widget build(BuildContext context) {
    final List<Widget> list = [
      Positioned(
        left: 0,
        top: 0,
        child: CustomPaint(
          size: widget.boxSize,
          painter: _PiecePainer(list: whiteList, color: Colors.white, update: !isWin && !isWhite),
        ),
      ),
      Positioned(
        left: 0,
        top: 0,
        child: CustomPaint(
          size: widget.boxSize,
          painter: _PiecePainer(list: blackList, color: Colors.black, update: !isWin && isWhite),
        ),
      )
    ];
    if (isWin) {
      list.add(Positioned(
        left: 75,
        top: 126,
        child: SizedBox(
          width: 150,
          height: 48,
          child: Material(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      return Transform.rotate(
                        angle: _controller.value,
                        child: Icon(Icons.refresh),
                      );
                    },
                  ),
                  onPressed: () {
                    _controller.animateTo(++rotateIndex * math.pi * 2);
                    setState(() {
                    whiteList = [];
                    blackList = [];
                    isWhite = true;
                    isWin = false; 
                    });
                  },
                ),
                Text('${isWhite ? 'black' : 'white'} win !!')
              ],
            ),
          ),
        ),
      ));
    }
    return Listener(
      child: Stack(
        children: list,
      ),
      onPointerDown: (event) {
        if (isWin) return;
        final Offset offset = Offset(_getPosition(event.position.dx - diffx), _getPosition(event.position.dy - diffy));
        
        if (whiteList.indexOf(offset) >= 0 || blackList.indexOf(offset) >= 0) return;
        setState(() {
          if (isWhite) whiteList.add(offset);
          else blackList.add(offset);
          _checkWhoWin(offset);
          isWhite = !isWhite;
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
  _PiecePainer({ this.list = const [], @required this.color, this.update }): super();
  final List<Offset> list;
  final Color color;
  final bool update;
  // 绘制黑白点
  _drawCircle (list, paint, color, canvas) {
    for(int i = 0; i < list.length; i++) {
      paint..color = color;
      canvas.drawCircle(list[i], 7.5, paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
    ..style = PaintingStyle.fill;
    _drawCircle(list, paint, color, canvas);
  }
  @override
  bool shouldRepaint(_PiecePainer oldDelegate) {
    return update;
  }
}
