import 'package:flutter/material.dart';
import 'dart:convert' show base64;

import './loading.dart';
import 'hero.dart' show HeroPage;
import 'package:flutter_demo/tools/const.dart' show errorImg;

typedef void Successhandler(bool isSuccess);

// 图片加载的状态
enum PlaceHolderImageStatus {
  loading,
  success,
  error
}

/**
 * 实现原理：利用了[ImageProvider]的[ImageProvider.resolve]方法实现，Image类下面的几个构造函数([Image.asset],[Image.network]...)都是基于[ImageProvider]实现，
 * 在Image Widget的build方法中最终都会去调用[ImageProvider.resolve]方法，该方法返回的是一个[Stream]，[Image]的实现上就是去根据得到的这个[Stream]来得到图片信息，最终渲染成图片的。
 * 另一方面，[ImageProvider]它有自己的一套缓存机制，它的子类需要实现匹配缓存功能，比如[NetworkImage]实现的[obtainKey]和[==]的功能，可以使得相同的路径的[NetworkImage]的请求接口会
 * 被缓存，所以本Widget([PlaceHolderImageDemo])的实现就是使用外部传入的[Image.image]属性值（类型是继承自[ImageProvider]），去执行它的resolve方法，触发加载图片资源，参数
 * 是[ImageConfiguration.empty]，不会影响图片结果，然后添加监听事件，处理成功和失败的两种情况，再加上[ImageProvider]的缓存机制，我们在成功的情况下，再将外部传入的Image挂载到tree上，
 * 这时外部的Image会直接使用缓存，从而实现想要的功能。
 * 
 */

/// 加载网络图片时的占位图片，并且处理了加载失败的逻辑；图片的宽高可以使用传入图片所设置的宽高，但是如果给占位图设置了宽度，
class PlaceHolderImageDemo extends StatefulWidget {
  PlaceHolderImageDemo(this._image, {
    Key key,
    Image error,
    this.loading = const LoadingDemo(speed: .6),
    this.hero = true,
    this.tag,
    this.successHandler,
  }) :  assert(!hero || tag != null, 'when [hero] is true, the [tag] is required'),
        error = new Image(image: MemoryImage(base64.decode(errorImg))),
        super(key: key);

  /// 要加载的图片
  final Image _image;

  /// 加载中的模块
  final Widget loading;

  /// 加载失败的模块
  final Widget error;

  /// 是否开启hero动画
  final bool hero;

  /// 如果[hero]为真，则[tag]是必传的
  final Object tag;

  final Successhandler successHandler;

  @override
  State<PlaceHolderImageDemo> createState() {
    return new _PlaceHolderImageState();
  }
}

class _PlaceHolderImageState extends State<PlaceHolderImageDemo> {
  PlaceHolderImageStatus status;
  ImageStream _stream;
  // 监听加载的回调
  _listener(ImageInfo imginfo, bool flag) {
    if (widget.successHandler != null) widget.successHandler(true);
    setState(() {
     status = PlaceHolderImageStatus.success;
    });
  }

  // 添加监听事件
  _addListener () {
    // loading..
    setState(() {
     status = PlaceHolderImageStatus.loading;
    });
    _stream = widget._image.image.resolve(ImageConfiguration.empty)
    ..addListener(
      _listener,
      onError: (exception, StackTrace stackTrace) {
        if (widget.successHandler != null) widget.successHandler(false);
        // 加载失败widget
        setState(() {
         status = PlaceHolderImageStatus.error; 
        });
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _addListener();
  }

  @override
  void didUpdateWidget(PlaceHolderImageDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._image != widget._image) {
      _stream?.removeListener(_listener);
      _addListener();
    }
  }

  @override
  void dispose() {
    _stream.removeListener(_listener);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    switch (status) {
      case PlaceHolderImageStatus.loading:
        return Center(child: widget.loading);
      case PlaceHolderImageStatus.success:
        return widget.hero ? HeroPage(child: widget._image, tag: widget.tag,) : widget._image;
      case PlaceHolderImageStatus.error:
        return widget.error;
      default:
        throw FlutterError('The state should be one of [PlaceHolderImageStatus.loading, PlaceHolderImageStatus.success, PlaceHolderImageStatus.error]');
    }
  }
}
