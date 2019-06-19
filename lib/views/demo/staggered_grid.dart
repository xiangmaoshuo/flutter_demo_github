import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'placeholder_image.dart' show PlaceHolderImageDemo;
import 'loading.dart' show LoadingDemo;
import 'package:flutter_demo/bloc/index.dart' show BlocBuilder, BlocProvider, FavorateBloc;
import '../../http/index.dart' show getGankJson;

class StaggeredGridDemo extends StatefulWidget {
  @override
  State<StaggeredGridDemo> createState() {
    return new _StaggeredGridDemoState();
  }
}

class _StaggeredGridDemoState extends State<StaggeredGridDemo> {

  final List<int> _randomList = new List<int>();
  final List<String> _countList = [];
  // 交叉轴总共分为几个等分单元
  final int _crossAxisCount = 6;
  // 交叉轴每个元素占据多少个等分单元
  final int _crossAxisCellCount = 2;
  // 是否已经加载完成
  bool _loadEnd = false;

  _getData(int page) {
    getGankJson(page).then((list) {
      setState(() {
        _loadEnd = list.isEmpty;
       _countList.addAll(list);
       for (int i = 0; i < 100; i ++) {
        _randomList.add(math.Random().nextInt(3) + 2);
      }
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final len = _countList.length;
    final cell = MediaQuery.of(context).size.width / _crossAxisCount;
    return StaggeredGridView.countBuilder(
      crossAxisCount: _crossAxisCount, // 将交叉轴（一般是手机的横轴）分为多少等分单元，这里是分为6等分单元
      itemCount: len + 1,
      itemBuilder: (context, index) {
        if (index == len) {
          if (_loadEnd) return LoadingDemo(loadingText: '莫得了，全部加载了...');
          _getData(len ~/ 10 + 1);
          return LoadingDemo(loadingText: '昨日像那东流水...', speed: .8,);
        }
        return Container(
          color: Colors.primaries[math.Random().nextInt(Colors.primaries.length)],
          child: Image.network(_countList[index], fit: BoxFit.contain,),
          // child: PlaceHolderImageDemo(
          //   Image.network(_countList[index], fit: BoxFit.cover,),
          //   width: cell * _crossAxisCellCount,
          //   height: cell * _randomList[index],
          //   tag: 'StaggeredGridDemo_$index',
          // ),
        );
      },
      staggeredTileBuilder: (index) {
        // 这个方法是给每一个tile设置其展示方式。
        // 第一个参数表示交叉轴（一般为手机横轴）占据多少等分单元，这里的多少等分单元是基于上面crossAxisCount来的，比如这里现在设置的是1，即占1等分单元，
        // 这样一来整个横轴有多少个tile也就确定了（crossAxisCount / crossAxisCellCount）。
        // 第二个参数是主轴所占的等分单元，这里也是基于crossAxisCount生成的等分单元来计算的
        final isLoading = index == len;
        return StaggeredTile.count(
          isLoading ? _crossAxisCount : _crossAxisCellCount,
          isLoading ? 1 : _randomList[index]
        );
      },
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
