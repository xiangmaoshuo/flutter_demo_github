import 'package:flutter/material.dart';
import '../../http/index.dart' show getFreeJson, ArticleListItem;
import './flutter_webview_plugin.dart';

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
  FloatingActionButton _topBtn;

  final ScrollController _scrollController = new ScrollController();
  bool _showTopBtn = false;

  List<ArticleListItem> _list = [];
  int _loadedPageCount = 0; // 已加载页数
  int _pageCount = 1; // 总共有多少页
  // 请求数据
  Future _getHttpData () async {
    final response = await getFreeJson(_loadedPageCount);
    setState(() {
     _loadedPageCount++;
     _pageCount = response.pageCount;
     _list.addAll(response.datas);
    });
  }

  // 跳转到webview展示的详情页面
  _turnToWebView (String url, [ String title ]) {
    Navigator.push(context, new MaterialPageRoute(
      builder: (context) {
        return new FlutterWebviewDemo(url, title: title);
      }
    ));
  }

  @override
  void initState() {
    _getHttpData();
    super.initState();
    final _number = 500;
    _scrollController.addListener(() {
      if (_scrollController.offset < _number && _showTopBtn) {
        setState(() {
         _showTopBtn = false;
        });
      } else if (_scrollController.offset >= _number && !_showTopBtn) {
        setState(() {
         _showTopBtn = true;
        });
      }
    });
    _topBtn = FloatingActionButton(
      child: Icon(Icons.arrow_upward),
      onPressed: () {
        _scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        controller: _scrollController,
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
          return ListTile(
            title: new Text(item.title),
            subtitle: Text('${item.author}   ${item.niceDate}'),
            onTap: () {
              _turnToWebView(item.link, item.title);
            },
          );
        },
      ),
      floatingActionButton: _showTopBtn ? _topBtn : null,
    );
  }
}
