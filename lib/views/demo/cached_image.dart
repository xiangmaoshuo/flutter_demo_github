import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;

class CachedImageDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: <Widget>[
            CachedNetworkImage(
              placeholder: (BuildContext context, String string) {
                return CircularProgressIndicator();
              },
              width: 200,
              imageUrl:
                  'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1850299945,3501159040&fm=26&gp=0.jpg',
            ),
            Image.network(
              'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1850299945,3501159040&fm=26&gp=0.jpg?12',
              width: 200,
            )
          ],
      )
    );
  }
}
