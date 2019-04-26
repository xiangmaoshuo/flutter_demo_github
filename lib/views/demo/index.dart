import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import '../../tools/event_bus.dart';
import 'dart:math' as math;

class Demo extends StatefulWidget {
  @override
  State<Demo> createState() {
    return new _DemoState();
  }
}

class _DemoState extends State<Demo> with SingleTickerProviderStateMixin {
  final List list = ['新闻', '历史', '图片'];
  int _selectedIndex = 0;
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: list.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('苑歌'),
        leading: Builder(builder: (context) {
          return IconButton(icon: Icon(Icons.memory), onPressed: () {
            Scaffold.of(context).openDrawer();
          },);
        },),
        bottom: TabBar(
          controller: _tabController,
          tabs: list.map((e) => Tab(text: e,)).toList(),
      )),
      drawer: Builder(builder: (context) {
        return Drawer(
          child: MediaQuery.removePadding(
            removeLeft: true,
            removeTop: true,
            context: context,
            child: Center(
              child: ClipOval(
                child: Image.asset('lib/images/demo.jpg',width: 80,),
              ),
            ),
          ),
        );
      },),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  width: 100,
                  height: 100,
                  child: Row(
                    children: <Widget>[
                      Image(image: AssetImage('lib/images/demo.jpg'), width: 100, height: 100, colorBlendMode: BlendMode.color, color: Colors.pink,),
                      Image(image: AssetImage('lib/images/demo.jpg'), width: 100, height: 100, colorBlendMode: BlendMode.color, color: Colors.yellow,)
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(width: 5, color: Colors.green),
                    // color: Colors.yellow,
                    // borderRadius: BorderRadius.all(Radius.circular(8)),
                    image: DecorationImage(image: AssetImage('lib/images/demo.jpg')),
                    shape: BoxShape.rectangle,
                    gradient: LinearGradient(colors: <Color>[Colors.green, Colors.amber])
                  ),
              ),
              Icon(Icons.zoom_out_map, color: Colors.blue,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
              RaisedButton.icon(icon: Icon(Icons.ac_unit),label: Text('2'), onPressed: (){}, color: Colors.pink[900], textColor: Colors.white,),
            ]
          ),
          Center(child: Text('历史'),),
          Center(child: Text('图片'),),
        ],
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
        child: Icon(Icons.colorize),
        onPressed: (){},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

