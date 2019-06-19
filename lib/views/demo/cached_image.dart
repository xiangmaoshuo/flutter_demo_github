import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import '../../http/index.dart' show getGankJson;
import 'placeholder_image.dart' show PlaceHolderImageDemo;
import 'loading.dart' show LoadingDemo;
import 'package:flutter_demo/bloc/index.dart' show BlocBuilder, BlocProvider, FavorateBloc;

class CachedImageDemo extends StatefulWidget {
  @override
  State<CachedImageDemo> createState() {
    return new _CachedImageDemoState();
  }
}

class _CachedImageDemoState extends State<CachedImageDemo> {
  List<String> _list = [];
  bool _loadEnd = false;

  _getData(int page) {
    getGankJson(page).then((list) {
      setState(() {
        _loadEnd = list.isEmpty;
       _list.addAll(list);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).primaryColor;
    final bloc = BlocProvider.of<FavorateBloc>(context);
    return Material(
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(color: Colors.transparent,);
        },
        itemCount: _list.length + 1,
        itemBuilder: (context, index) {
          if (index == _list.length) {
            if (_loadEnd) return Text('我是有底线的...', textAlign: TextAlign.center,);
            _getData(_list.length ~/ 10 + 1);
            return LoadingDemo(loadingText: '求豆麻袋...');
          }
          bool isSuccess = false;
          return GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            child: Stack(
              children: <Widget>[
                PlaceHolderImageDemo(
                  Image.network(_list[index], fit: BoxFit.fitWidth, width: width, height: width,),
                  hero: true,
                  tag: 'CachedImageDemo-$index',
                  successHandler: (flag) { isSuccess = flag; },
                ),
                Positioned(
                  right: 0,
                  child: BlocBuilder(
                    bloc: bloc,
                    builder: (context, List<String> state) {
                      return Icon(Icons.favorite, color: state.contains(_list[index]) ? primaryColor : Colors.transparent,);
                    },
                  ),
                )
              ],
            ),
            onDoubleTap: () {
              if (isSuccess) {
                final list = bloc.currentState.sublist(0);
                final currentItem = _list[index];
                if (list.contains(currentItem)) list.remove(currentItem);
                else list.add(currentItem);
                if (list.length > 2) list.removeAt(0); // 只保留2个
                bloc.dispatch(list);
              }
            },
          );
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
