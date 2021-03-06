import 'package:flutter/material.dart';

// 底部导航的类型，支持两种
enum BottomBarType {
  navigation,
  app
}

// 底部导航的每一个item的类型
class BottomBarItemType {
  final String text;
  final IconData icon;
  const BottomBarItemType({
    @required this.icon,
    this.text = ''
  });
}

// 对外直接使用的自带底部导航的Scaffed
class ScaffedWithBottomBarDemo extends StatefulWidget {
  final List<Widget> views;
  final BottomBarType type;
  final List<BottomBarItemType> items;
  final int currentIndex;
  ScaffedWithBottomBarDemo({
    @required this.views,
    @required this.items,
    this.type = BottomBarType.app,
    this.currentIndex = 0,
    Key key
  }): assert(
      views != null
      && items != null
      && views.isNotEmpty
      && items.isNotEmpty
      && views.length == items.length
    ),
    super(key: key);

  @override
  State<ScaffedWithBottomBarDemo> createState() {
    return new _ScaffedWithBottomBarDemoState();
  }
}

class _ScaffedWithBottomBarDemoState extends State<ScaffedWithBottomBarDemo> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: widget.views.map((item) {
          return _KeepAliveDemo(child: item);
        }).toList(),
      ),
      bottomNavigationBar: _ShareDataWidget(
        child: _BottomNavigationBarDemo(controller: _pageController),
        items: widget.items,
        type: widget.type,
        currentIndex: widget.currentIndex,
      ),
    );
  }
}

class _KeepAliveDemo extends StatefulWidget {
  _KeepAliveDemo({ Key key, this.child }) : super(key: key);
  final Widget child;
  @override
  State<_KeepAliveDemo> createState() {
    return new __KeepAliveDemoState();
  }
}

class __KeepAliveDemoState extends State<_KeepAliveDemo> with AutomaticKeepAliveClientMixin {
  get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}


// 底部导航栏的内部实现
class _BottomNavigationBarDemo extends StatefulWidget {
  final PageController controller;
  _BottomNavigationBarDemo({
    Key key,
    @required this.controller
  }): super(key: key);

  @override
  State<_BottomNavigationBarDemo> createState() {
    return new _BottomNavigationBarDemoState();
  }
}

class _BottomNavigationBarDemoState extends State<_BottomNavigationBarDemo> {
  Duration _duration = Duration(milliseconds: 300);
  int _currentIndex;
  _ShareDataWidget _store;
  
  @override
  void initState() {
    super.initState();
    final _controller = widget.controller;
    _controller.addListener(() {
      setState(() {
        _currentIndex = _controller.page.round(); 
      });
    });
  }

  _changeCurrentIndex(int i) {
    setState(() {
      _currentIndex = i; 
    });
    assert(widget.controller != null); // 判断一下
    widget.controller.animateToPage(i, duration: _duration, curve: Curves.easeOut);
  }

  @override
  void didChangeDependencies() {
    _store = _ShareDataWidget.of(context);
    _currentIndex = _store.currentIndex;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Color _color = Theme.of(context).primaryTextTheme.body2.color;
  
    return Builder(
      builder: (context) {
        switch (_store.type) {
          case BottomBarType.app:
            int index = 0;
            return BottomAppBar(
              child: Row(
                children: _store.items.map((item) {
                  final _i = index;
                  final __color = _currentIndex == _i ? _color : _color.withAlpha(0xB2);
                  index ++;
                  return IconButton(icon: Icon(item.icon, color: __color), onPressed: () => _changeCurrentIndex(_i),);
                }).toList(),
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
            );
          default:
            return BottomNavigationBar( // 底部导航
            items: _store.items.map((item) => BottomNavigationBarItem(icon: Icon(item.icon), title: Text(item.text))).toList(),
            type: BottomNavigationBarType.fixed, // fixed, shifting; fixed 一直显示icon和text，shifting只在active的item上显示text
            currentIndex: _currentIndex,
            onTap: _changeCurrentIndex,
          );
        } 
      },
    );
  }
}

// 声明一个上下文widget，以方便传递数据
class _ShareDataWidget extends InheritedWidget {
  final List<BottomBarItemType> items;
  final BottomBarType type;
  final int currentIndex;
  _ShareDataWidget({
    @required Widget child,
    @required this.items,
    @required this.type,
    @required this.currentIndex,
  }): assert(child != null),
      super(child: child);

  static _ShareDataWidget of (BuildContext context) {
    return context.inheritFromWidgetOfExactType(_ShareDataWidget);
  }

  @override
  bool updateShouldNotify(_ShareDataWidget oldWidget) {
    return (oldWidget.items != items)
    || (oldWidget.type != type)
    || (oldWidget.currentIndex != currentIndex);
  }
}



