import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class FlutterWebviewDemo extends StatefulWidget {
  FlutterWebviewDemo(this._url, { this.title });
  
  final String _url;
  final String title;

  @override
  State<FlutterWebviewDemo> createState() {
    return new _FlutterWebviewDemoState();
  }
}

class _FlutterWebviewDemoState extends State<FlutterWebviewDemo> {
  // final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    // flutterWebviewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget._url,
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}
