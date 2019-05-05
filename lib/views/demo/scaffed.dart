import 'package:flutter/material.dart';

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
        title: Text('苑歌'),
        leading: Builder(builder: (context) {
          return IconButton(icon: Icon(Icons.person), onPressed: () => Scaffold.of(context).openDrawer(),);
        },),
        bottom: TabBar(
          controller: _tabController,
          tabs: list.map((e) => Tab(text: e,)).toList(),
      )),
      drawer: widget.drawer,
      body: TabBarView(
        controller: _tabController,
        children: widget.children,
      ),
      // bottomNavigationBar: BottomNavigationBar( // 底部导航
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
      //     BottomNavigationBarItem(icon: Icon(Icons.business), title: Text('Business')),
      //     BottomNavigationBarItem(icon: Icon(Icons.school), title: Text('School')),
      //   ],
      //   currentIndex: _selectedIndex,
      //   fixedColor: Colors.blue,
      //   onTap: (int index) {
      //     setState(() {
      //      _selectedIndex = index; 
      //     });
      //   },
      // ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        shape: CircularNotchedRectangle(),
        child: Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.home), onPressed: () {}, color: Colors.white,),
            SizedBox(),
            IconButton(icon: Icon(Icons.home), onPressed: () {}, color: Colors.white,),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
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
