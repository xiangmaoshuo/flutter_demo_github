import 'package:flutter/material.dart';
import '../../tools/http.dart' show getFreeJson, Response;

class HttpDemo extends StatefulWidget {
  @override
  State<HttpDemo> createState() {
    return new _HttpDemoState();
  }
}

class _HttpDemoState extends State<HttpDemo> {
  bool _loading = false;
  Response _response;
  RaisedButton _reloadButton;
  final SizedBox _loadingBox = SizedBox(
    height: 24.0,
    width: 24.0,
    child: CircularProgressIndicator(strokeWidth: 2.0,),
  );
  Future _getHttpData () async {
    setState(() {
     _loading = true; 
    });
    final Response response = await getFreeJson(1);
    print(response.data);
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
        Text('${_response.request.uri.toString()}:', style: TextStyle(color: Theme.of(context).primaryColor),),
        Text(_response.data.toString())
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
