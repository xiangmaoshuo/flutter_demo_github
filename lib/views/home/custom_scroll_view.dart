import 'package:flutter/material.dart';

class CustomScrollViewDemo extends StatefulWidget {
  @override
  State<CustomScrollViewDemo> createState() {
    return new _CustomScrollViewDemoState();
  }
}

class _CustomScrollViewDemoState extends State<CustomScrollViewDemo> {
  String str = '0%';
  ScrollController _controller = new ScrollController();
  bool showTopBtn = false;

  @override
  void initState() {
    super.initState();
    final number = 190;
    _controller.addListener(() {
      if (_controller.offset < number && showTopBtn) {
        setState(() {
         showTopBtn = false;
        });
      } else if (_controller.offset >= number && !showTopBtn) {
        setState(() {
         showTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          setState(() {
           str = '${(notification.metrics.pixels / notification.metrics.maxScrollExtent * 100).toInt()}%'; 
          });
          return true;
        },
        child: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            SliverAppBar(
              title: showTopBtn ? Text('朋友圈') : null,
              actions: showTopBtn ? <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(str, textAlign: TextAlign.center,),
                ),
                IconButton(icon: Icon(Icons.touch_app), onPressed: () {
                  _controller.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.ease);
                },)
              ] : null,
              pinned: true, // 固定头部
              expandedHeight:250.0,
              flexibleSpace: FlexibleSpaceBar(
                title: showTopBtn ? null : const Text('custom_scroll_view', style: TextStyle(color: Colors.white),),
                background: Image.asset('lib/images/demo.jpg', fit: BoxFit.cover, color: Colors.red, colorBlendMode: BlendMode.difference,),
              )
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //Grid按两列显示
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 4.0,
                ),
                delegate: new SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    //创建子widget      
                    return new Container(
                      alignment: Alignment.center,
                      color: Colors.cyan[100 * (index % 9)],
                      child: new Text('grid item $index'),
                    );
                  },
                  childCount: 20,
                ),
              ),
            ),
            new SliverFixedExtentList(
              itemExtent: 50.0,
              delegate: new SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    //创建列表项      
                    return new Container(
                      alignment: Alignment.center,
                      color: Colors.lightBlue[100 * (index % 9)],
                      child: new Text('list item $index'),
                    );
                  },
                  childCount: 50 //50个列表项
              ),
            )
          ],
        ),
      ),
    );
  }
}
