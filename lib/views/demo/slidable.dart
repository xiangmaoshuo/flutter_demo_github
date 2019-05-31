import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableDemo extends StatefulWidget {
  @override
  State<SlidableDemo> createState() {
    return new _SlidableDemoState();
  }
}

class _SlidableDemoState extends State<SlidableDemo> {
  final Divider _divider = Divider(height: 6.0, color: Colors.transparent);
  final _actions = <Widget>[
    new IconSlideAction(
      caption: 'Archive',
      color: Colors.blue,
      icon: Icons.archive,
    ),
    new IconSlideAction(
      caption: 'Share',
      color: Colors.indigo,
      icon: Icons.share,
    ),
  ];
  final _secondaryActions = <Widget>[
    new IconSlideAction(
      caption: 'More',
      color: Colors.black45,
      icon: Icons.more_horiz,
    ),
    Builder(
      builder: (context) {
        return IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            print('onTap true');
            Slidable.of(context).close(); // 虽然设置了closeOnTap：false，但是可以手动调用关闭
          },
          closeOnTap: false,
        );
      },
    ),
  ];
  final SlidableController _controller = SlidableController();
  int number = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData _themeData = Theme.of(context);
    return Material(
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return _divider;
        },
        itemCount: 30,
        itemBuilder: (context, index) {
          return Slidable(
            key: Key('$index'),
            slideToDismissDelegate: SlideToDismissDrawerDelegate(
              onDismissed: (type) {
                print(type);
              }
            ),
            controller: _controller,
            closeOnScroll: true, // 为false时，感觉有bug
            delegate: SlidableDrawerDelegate(),
            actionExtentRatio: 0.2,
            child: CustomPaint(
              painter: _BgPainer(),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _themeData.primaryColor,
                  child: Text('${index + 1}'),
                  foregroundColor: _themeData.primaryTextTheme.body2.color,
                ),
                title: Text('Tile for ${index + 1} - $number'),
                subtitle: Text('SubTitle for ${index + 1} - $number')
              ),
            ),
            actions: _actions,
            secondaryActions: _secondaryActions,
          );
        }
      ),
    );
  }
}

class _BgPainer extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景（白色）
    Paint paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..color = Colors.white;
    canvas.drawRect(Offset.zero & size, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
