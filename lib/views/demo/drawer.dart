import 'package:flutter/material.dart';
import 'custom_scroll_view.dart';
import 'animation.dart';
import 'home/index.dart';
import 'listener/pointer.dart';
import 'listener/gesture.dart';
import 'customPaint.dart';
import 'slidable.dart';
import 'http.dart';
import 'flutter_webview_plugin.dart';
import 'hero.dart' show HeroPage;

class DrawerDemo extends StatelessWidget {
  final _headerImg = Image.asset('lib/images/launch_background.png',width: 40, height: 40, fit: BoxFit.fitWidth,);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Drawer(
          child: MediaQuery.removePadding(
            removeLeft: true,
            removeTop: true,
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 10.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: ClipOval(
                          child: HeroPage(child: _headerImg, tag: #header,),
                        ),
                      ),
                      Text('恰当的模样', style: TextStyle(
                        fontSize: 14.0
                      ),)
                    ],
                  ),
                ),
                Divider(color: Theme.of(context).primaryColor,),
                Expanded(
                  child: _DrawerList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

typedef Widget _GetWidget();
class _KeyValue {
  final String title;
  final String subTitle;
  final _GetWidget value;
  const _KeyValue({this.title, this.subTitle, this.value});
}

class _DrawerList extends StatefulWidget {
  @override
  State<_DrawerList> createState() {
    return new __DrawerListState();
  }
}

class __DrawerListState extends State<_DrawerList> {
  final List<_KeyValue> list = [
    _KeyValue(title: 'Home', subTitle: '一个拥有交互的列表demo，外加结合eventBus实现修改主题颜色demo', value: () => Home()),
    _KeyValue(title: 'CustomScrollViewDemo', subTitle: '类似朋友圈的列表demo', value: () => CustomScrollViewDemo()),
    _KeyValue(title: 'PointerDemo', subTitle: '监听点击事件的demo', value: () => PointerDemo()),
    _KeyValue(title: 'GestureDemo', subTitle: '手势相关的demo', value: () => GestureDemo()),
    _KeyValue(title: 'AnimationDemo', subTitle: '动画相关的demo', value: () => AnimationDemo()),
    _KeyValue(title: 'CustomPaintDemo', subTitle: '自绘UI的demo', value: () => CustomPaintDemo()),
    _KeyValue(title: 'SlidableDemo', subTitle: '列表滑动显示操作项demo', value: () => SlidableDemo()),
    _KeyValue(title: 'HttpDemo', subTitle: 'http请求demo', value: () => HttpDemo()),
    _KeyValue(title: 'FlutterWebviewDemo', subTitle: 'http请求demo', value: () => FlutterWebviewDemo('https://gank.io/xiandu')),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (BuildContext context, int index) => Divider(color: Theme.of(context).primaryColor,),
      itemBuilder: (context, index) {
        final item = list[index];
        return ListTile(
          title: Text(item.title),
          subtitle: Text(item.subTitle),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => item.value()
            ));
          }
        );
      },
    );
  }
}

