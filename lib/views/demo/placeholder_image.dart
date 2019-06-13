import 'package:flutter/material.dart';
import './loading.dart';

/**
 * 实现原理：利用了[ImageProvider]的[ImageProvider.resolve]方法实现，Image类下面的几个构造函数([Image.asset],[Image.network]...)都是基于[ImageProvider]实现，
 * 在Image Widget的build方法中最终都会去调用[ImageProvider.resolve]方法，该方法返回的是一个[Stream]，[Image]的实现上就是去根据得到的这个[Stream]来得到图片信息，最终渲染成图片的。
 * 另一方面，[ImageProvider]它有自己的一套缓存机制，它的子类需要实现匹配缓存功能，比如[NetworkImage]实现的[obtainKey]和[==]的功能，可以使得相同的路径的[NetworkImage]的请求接口会
 * 被缓存，所以本Widget([PlaceHolderImageDemo])的实现就是使用外部传入的[Image.image]属性值（类型是继承自[ImageProvider]），去执行它的resolve方法，触发加载图片资源，参数
 * 是[ImageConfiguration.empty]，不会影响图片结果，然后添加监听事件，处理成功和失败的两种情况，再加上[ImageProvider]的缓存机制，我们在成功的情况下，再将外部传入的Image挂载到tree上，
 * 这时外部的Image会直接使用缓存，从而实现想要的功能。
 * 
 */

/// 加载网络图片时的占位图片，并且处理了加载失败的逻辑；
class PlaceHolderImageDemo extends StatefulWidget {
  PlaceHolderImageDemo(this._image, {
    Key key,
    @required this.width,
    this.aspect = 1,
    this.loading = const LoadingDemo(),
    this.error = const LoadingDemo(loadingText: '加载失败',),
  }) : super(key: key);

  /// 要加载的图片
  final Image _image;

  /// 加载中的模块， 默认是[const LoadingDemo()]
  final Widget loading;

  /// 加载失败的模块，默认提示：error文本
  final Widget error;

  /// 图片的宽度，必传
  final double width;

  /// 图片的宽高比，默认是1：1
  final double aspect;
  @override
  State<PlaceHolderImageDemo> createState() {
    return new _PlaceHolderImageState();
  }
}

class _PlaceHolderImageState extends State<PlaceHolderImageDemo> {
  Widget _finalImage;
  ImageStream _stream;
  /// 对外暴露，当前图片是否加载完成
  bool isSuccess = false;

  // 监听加载的回调
  _listener(ImageInfo imginfo, bool flag) {
    isSuccess = true;
    _finalImage = widget._image;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // loading..
    _finalImage = widget.loading;
    _stream = widget._image.image.resolve(ImageConfiguration.empty)
    ..addListener(
      _listener,
      onError: (exception, StackTrace stackTrace) {
        isSuccess = false;
        // 加载失败widget
        _finalImage = widget.error;
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
    final width = widget.width;
    return Container(
      color: Colors.white,
      width: width,
      height: width * widget.aspect,
      child: Center(child: _finalImage,),
    );
  }
}