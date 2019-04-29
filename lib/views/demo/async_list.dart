import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

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

  _addStrlist() {
    Future.delayed(Duration(seconds: 2)).then((e) {
      setState(() {
        _strList.insertAll(
        _strList.length - 1,
        generateWordPairs().take(20).map((e) => e.asPascalCase).toList()
      );
      });
    });
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
              child: SizedBox(
                height: 24.0,
                width: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0,),
              ),
            );
          } else {
            return Center(child: Text('没有更多了'),);
          }
        }
        
        final String item = _strList[index];

        // 滑动删除
        return Dismissible(
          background: new Container(color: Theme.of(context).primaryColor,),
          child: ListTile(title: new Text('item---$index---$item'), subtitle: Text('11111')),
          key: Key(item),
          onDismissed: (direction) {
            setState(() {
              _strList.remove(item); 
            });
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("item:[$item] dismissed")));
          },
        );
      },
    );
  }
}
