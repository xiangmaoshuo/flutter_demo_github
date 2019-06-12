import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import '../../http/index.dart' show getGankJson;
import '../../tools/event_bus.dart';
import 'placeholder_image.dart';
class CachedImageDemo extends StatefulWidget {
  @override
  State<CachedImageDemo> createState() {
    return new _CachedImageDemoState();
  }
}

class _CachedImageDemoState extends State<CachedImageDemo> {
  List _list = [];
  bool _loadEnd = false;

  _getData() {
    getGankJson().then((list) {
      setState(() {
        _loadEnd = list.isEmpty;
       _list.addAll(list);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(color: Colors.transparent,);
        },
        itemCount: _list.length + 1,
        itemBuilder: (context, index) {
          if (index == _list.length) {
            if (_loadEnd) return Text('我是有底线的...', textAlign: TextAlign.center,);
            _getData();
            return Text('求豆麻袋...', textAlign: TextAlign.center,);
          }
          return PlaceHolderImageDemo(Image.network(_list[index]));
          // return Image.network(_list[index]); // 自带的这种不会缓存
          // // 下面这种会缓存
          // return CachedNetworkImage(
          //   placeholder: (BuildContext context, String string) {
          //     return CircularProgressIndicator();
          //   },
          //   imageUrl: _list[index],
          // );
        },
      ),
    );
  }
}
