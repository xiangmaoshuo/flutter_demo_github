import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StaggeredGridDemo extends StatefulWidget {
  @override
  State<StaggeredGridDemo> createState() {
    return new _StaggeredGridDemoState();
  }
}

class _StaggeredGridDemoState extends State<StaggeredGridDemo> {

  final List<int> _randomList = new List<int>();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 100; i ++) {
      _randomList.add(math.Random().nextInt(3) + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 6, // 将交叉轴（一般是手机的横轴）分为多少等分单元，这里是分为2等分单元
      itemCount: 100,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.primaries[math.Random().nextInt(Colors.primaries.length)],
          child: new Center(
            child: new CircleAvatar(
              backgroundColor: Colors.white,
              child: new Text('$index'),
            ),
          )
        );
      },
      staggeredTileBuilder: (index) {
        // 这个方法是给每一个tile设置其展示方式。
        // 第一个参数表示交叉轴（一般为手机横轴）占据多少等分单元，这里的多少等分单元是基于上面crossAxisCount来的，比如这里现在设置的是1，即占1等分单元，
        // 这样一来整个横轴有多少个tile也就确定了（crossAxisCount / crossAxisCellCount）。
        // 第二个参数是主轴所占的等分单元，这里也是基于crossAxisCount生成的等分单元来计算的
        return StaggeredTile.count(2, _randomList[index]);
      },
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
