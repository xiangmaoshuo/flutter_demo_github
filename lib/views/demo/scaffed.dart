import 'package:flutter/material.dart';
import 'message.dart';

class ScaffedDemo extends StatefulWidget {
  ScaffedDemo({Key key, this.drawer, this.children}): super();
  final Widget drawer;
  final List<Widget> children;
  @override
  State<ScaffedDemo> createState() {
    return new _ScaffedDemoState();
  }
}

class _ScaffedDemoState extends State<ScaffedDemo> with SingleTickerProviderStateMixin {

  final List list = ['容器', '图片', '按钮', '列表', '路由', '栅格'];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: list.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('天歌'),
        leading: Builder(builder: (context) {
          return IconButton(icon: Icon(Icons.person), onPressed: () => Scaffold.of(context).openDrawer(),);
        },),
        bottom: TabBar(
          controller: _tabController,
          tabs: list.map((e) => Tab(text: e,)).toList(),
      )),
      drawer: widget.drawer,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          TabBarView(
            controller: _tabController,
            children: widget.children.map((item) {
              return _TabBarChild(child: item,);
            }).toList(),
          ),
          MessageDemo(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.notifications),
        onPressed: (){
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('温馨提醒'),
                content: Text('所有TabView都是自己在管理state，所以每次切换都会导致状态的改变，如果不想这样，可以将state提升到根widget上管理'),
                actions: <Widget>[
                  Text('1'),
                  Text('2')
                ],
              );
            }
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _TabBarChild extends StatefulWidget {
  _TabBarChild({ Key key, this.child }) : super(key: key);
  final Widget child;
  @override
  State<_TabBarChild> createState() {
    return new __TabBarChildState();
  }
}

class __TabBarChildState extends State<_TabBarChild> with AutomaticKeepAliveClientMixin {

  get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

