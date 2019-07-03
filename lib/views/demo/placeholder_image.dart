import 'package:flutter/material.dart';
import 'dart:convert' show base64;

import './loading.dart';
import 'hero.dart' show HeroPage;
import 'package:flutter_demo/tools/const.dart' show errorImg;
import 'package:flutter_demo/bloc/index.dart' show StateDispatchBloc;

typedef void Successhandler(bool isSuccess, ImageInfo imginfo, bool flag );

class PlaceHolderCallbackType {
  PlaceHolderCallbackType({
    this.status,
    this.imgInfo,
  });
  final PlaceHolderImageStatus status;
  final ImageInfo imgInfo;
}

/// 定义一个bloc，用于传递[PlaceHolderImageDemo]内部图片加载的状态，以及图片信息
class PlaceHolderImgBloc extends StateDispatchBloc<PlaceHolderCallbackType> {
  PlaceHolderImgBloc(): super(PlaceHolderCallbackType(status: PlaceHolderImageStatus.loading));
}

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

/// 图片通过该Widget加载时，会用loading效果，如果加载失败，会有error效果，loading和error效果可以自定义；
/// 集成了hero动画，以方便查看大图，详情查看[HeroPage]，当打开hero动画时，需要传入[tag]
class PlaceHolderImageDemo extends StatefulWidget {
  PlaceHolderImageDemo({
    Key key,
    this.image,
    Image error,
    this.loading = const LoadingDemo(speed: .6),
    this.hero = true,
    this.tag,
    this.fit = BoxFit.contain,
  }) :  assert(!hero || tag != null, 'when [hero] is true, the [tag] is required'),
        error = new Image(image: MemoryImage(base64.decode(errorImg))),
        super(key: key);

  /// 要加载的图片
  final ImageProvider image;

  final BoxFit fit;

  /// 加载中的模块
  final Widget loading;

  /// 加载失败的模块
  final Widget error;

  /// 是否开启hero动画
  final bool hero;

  /// 如果[hero]为真，则[tag]是必传的
  final Object tag;

  /// 每个占位图都对应一个bloc
  final PlaceHolderImgBloc bloc = PlaceHolderImgBloc();

  @override
  State<PlaceHolderImageDemo> createState() {
    return new _PlaceHolderImageState();
  }
}

class _PlaceHolderImageState extends State<PlaceHolderImageDemo> {
  PlaceHolderImageStatus _status;
  ImageStream _stream;
  Image _img;
  ImageInfo _imageInfo;
  // 监听加载的回调
  _listener(ImageInfo imginfo, bool flag) {
    _imageInfo = imginfo;
    _dispatch(imginfo: imginfo, status: PlaceHolderImageStatus.success);
  }

  _dispatch ({ PlaceHolderImageStatus status, ImageInfo imginfo }) {
    if (mounted) {
      setState(() {
        _status = status;
      });
      widget.bloc.dispatch(PlaceHolderCallbackType(imgInfo: imginfo, status: _status));
    }
  }

  // 添加监听事件
  _addListener () {
    _img = Image(image: widget.image, fit: widget.fit,);
    // loading..
    _status = PlaceHolderImageStatus.loading;
    widget.bloc.dispatch(PlaceHolderCallbackType(status: _status));

    // 监听图片流是否正常
    _stream = widget.image.resolve(ImageConfiguration.empty)
    ..addListener(
      _listener,
      onError: (exception, StackTrace stackTrace) {
        _dispatch(status: PlaceHolderImageStatus.error);
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
    
    if (oldWidget.image != widget.image) {
      _stream?.removeListener(_listener);
      _addListener();
    } else {
      widget.bloc.dispatch(PlaceHolderCallbackType(imgInfo: _imageInfo, status: _status));
    }
  }

  @override
  void dispose() {
    _stream.removeListener(_listener);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case PlaceHolderImageStatus.loading:
        return Center(child: widget.loading);
      case PlaceHolderImageStatus.success:
        return widget.hero ? HeroPage(child: _img, tag: widget.tag,) : _img;
      case PlaceHolderImageStatus.error:
        return widget.error;
      default:
        throw FlutterError('The state should be one of [PlaceHolderImageStatus.loading, PlaceHolderImageStatus.success, PlaceHolderImageStatus.error]');
    }
  }
}
