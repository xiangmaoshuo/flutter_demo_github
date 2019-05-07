import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:async' show Timer;
class AsyncListDemo extends StatefulWidget {
  @override
  State<AsyncListDemo> createState() {
    return new _AsyncListDemoState();
  }
}

class _AsyncListDemoState extends State<AsyncListDemo> {

  final Widget _divider1 = Divider(color: Colors.blue, height: .0,);
  final Widget _divider2 = Divider(color: Colors.green, height: .0,);
  final List _strList = [#loadingFlag];
  Timer _timer;
  
  // 一进入会调用，往下滚动时会调用
  _addStrlist() {
    _timer = Timer(Duration(seconds: 2), () {
      setState(() {
        _strList.insertAll(
        _strList.length - 1,
        generateWordPairs().take(20).map((e) => e.asPascalCase).toList()
      );
      });
    });
  }

  @override
  void dispose() {
    // 取消定时器
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return index % 2 == 0 ? _divider1 : _divider2;
      },
      itemCount: _strList.length,
      itemBuilder: (BuildContext context, int index) {
          if (_strList[index] == #loadingFlag) {
            if (_strList.length < 100) {
            _addStrlist();
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                child: SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: CircularProgressIndicator(strokeWidth: 2.0,),
                ),
              )
            );
          } else {
            return Center(child: Text('没有更多了'),);
          }
        }
        
        final String item = _strList[index];

        // 滑动删除
        return Dismissible(
          background: new Container(color: Theme.of(context).primaryColor,),
          child: ListTile(title: new Text('item---$index---$item')),
          key: Key(item),
          onDismissed: (direction) {
            setState(() {
              _strList.remove(item); 
            });
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("item:[$index] dismissed")));
          },
        );
      },
    );
  }
}
