import 'package:flutter/material.dart';
class PlaceHolderImageDemo extends StatefulWidget {
  PlaceHolderImageDemo(this._image);
  final Image _image;
  @override
  State<PlaceHolderImageDemo> createState() {
    return new _PlaceHolderImageState();
  }
}

class _PlaceHolderImageState extends State<PlaceHolderImageDemo> {
  Widget _finalImage;
  ImageStream _stream;
  // 对外暴露
  bool isSuccess = false;

  // 监听加载的回调
  _listener(imginfo, flag) {
    isSuccess = true;
    _finalImage = widget._image;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 获取最大宽度
    final width = MediaQuery.of(context).size.width;
    // loading..
    _finalImage = SizedBox(
      width: width,
      height: width,
      child: Center(child: Text('loading...'),),
    );
    _stream = widget._image.image.resolve(ImageConfiguration.empty)
    ..addListener(
      _listener,
      onError: (exception, StackTrace stackTrace) {
        isSuccess = false;
        // 加载失败widget
        _finalImage = SizedBox(
          width: width,
          height: width,
          child: Center(child: Text('error'),)
        );
      }
    );
  }

  @override
  void dispose() {
    _stream.removeListener(_listener);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return _finalImage;
  }
}