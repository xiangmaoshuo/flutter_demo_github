import 'package:flutter/material.dart';

import 'container.dart';
import 'drawer.dart';
import 'cached_image.dart';
import 'inkwell_button.dart';
import 'async_list.dart';
import 'route.dart';
import 'staggered_grid.dart';
import 'scaffed.dart';
import 'scaffed_with_bottom_bar.dart';
import 'custom_scroll_view.dart';

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffedWithBottomBarDemo(
      items: [
        const BottomBarItemType(icon: Icons.home, text: '首页'),
        const BottomBarItemType(icon: Icons.camera, text: '朋友圈'),
      ],
      views: <Widget>[
        ScaffedDemo(
          children: <Widget>[
            ContainerDemo(),
            CachedImageDemo(),
            InkWellButtonDemo(),
            AsyncListDemo(),
            RouteDemo(),
            StaggeredGridDemo()
          ],
          drawer: DrawerDemo(),
        ),
        CustomScrollViewDemo(),
      ],
    );
  }
}
