import 'package:flutter/material.dart';

import 'container.dart';
import 'drawer.dart';
import 'cached_image.dart';
import 'inkwell_button.dart';
import 'async_list.dart';
import 'route.dart';
import 'staggered_grid.dart';
import 'scaffed.dart';

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffedDemo(
      children: <Widget>[
        ContainerDemo(),
        CachedImageDemo(),
        InkWellButtonDemo(),
        AsyncListDemo(),
        RouteDemo(),
        StaggeredGridDemo()
      ],
      drawer: DrawerDemo(),
    );
  }
}
