import 'package:flutter/material.dart';
import '../../http/index.dart' show getFreeJson, ArticleListItem;

class HttpDemo extends StatefulWidget {
  @override
  State<HttpDemo> createState() {
    return new _HttpDemoState();
  }
}

class _HttpDemoState extends State<HttpDemo> {
  final Widget _divider1 = Divider(color: Colors.blue, height: .0,);
  final Widget _divider2 = Divider(color: Colors.green, height: .0,);
  final Widget _loadingBox = Center(
    child: Padding(
      padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: SizedBox(
        height: 24.0,
        width: 24.0,
        child: CircularProgressIndicator(strokeWidth: 2.0,),
      ),
    )
  );
  final Widget _nomoreBox = Center(child: Text('没有更多了'));

  List<ArticleListItem> _list = [];
  int _loadedPageCount = 0; // 已加载页数
  int _pageCount = 1; // 总共有多少页
  double _paddingTop;
  // 请求数据
  Future _getHttpData () async {
    final response = await getFreeJson(_loadedPageCount);
    setState(() {
     _loadedPageCount++;
     _pageCount = response.pageCount;
     _list.addAll(response.datas);
    });
  }

  @override
  void initState() {
    _getHttpData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _paddingTop = MediaQuery.of(context).padding.top;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return index % 2 == 0 ? _divider1 : _divider2;
        },
        itemCount: _list.length + 1,
        itemBuilder: (BuildContext context, int index) {
            // 如果当前已经是最后一个条目时，进行判断
            if (index == _list.length) {
              // 如果已加载页数小于总页数，则显示loading，并请求数据
              if (_loadedPageCount < _pageCount) {
                _getHttpData();
                return _loadingBox;
              }
              return _nomoreBox;
          }
          
          final ArticleListItem item = _list[index];

          // 滑动删除
          return ListTile(title: new Text(item.title), subtitle: Text('${item.author}   ${item.niceDate}'));
        },
      )
    );
  }
}
