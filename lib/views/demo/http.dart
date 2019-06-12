import 'package:flutter/material.dart';
import '../../http/index.dart' show getFreeJson, ArticleList;

class HttpDemo extends StatefulWidget {
  @override
  State<HttpDemo> createState() {
    return new _HttpDemoState();
  }
}

class _HttpDemoState extends State<HttpDemo> {
  bool _loading = false;
  ArticleList _response;
  RaisedButton _reloadButton;

  final SizedBox _loadingBox = SizedBox(
    height: 24.0,
    width: 24.0,
    child: CircularProgressIndicator(strokeWidth: 2.0,),
  );

  // 请求数据
  Future _getHttpData () async {
    setState(() {
     _loading = true; 
    });
    final ArticleList response = await getFreeJson(1);
    print(response.toJson());
    setState(() {
     _loading = false;
     _response = response;
    });
  }

  @override
  void initState() {
    super.initState();
    _reloadButton = RaisedButton(
      child: Text('reload'),
      onPressed: _getHttpData,
    );
    _getHttpData();
  }

  @override
  Widget build(BuildContext context) {

    final _children = <Widget>[];
    _children.add(_reloadButton);
    if (_loading) {
      _children.add(_loadingBox);
    } else {
      _children.addAll([
        Text(_response.toJson().toString())
      ]);
    }

    return Material(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: SingleChildScrollView(
          child: Column(
            children: _children,
          ),
        ),
      ),
    );
  }
}
