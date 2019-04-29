import 'package:flutter/material.dart';

class Favorite extends StatelessWidget {
  Favorite(this.favorites, this.textStyle);
  final Set favorites;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('favorite list')),
      body: ListView(
        children: ListTile.divideTiles(
          tiles: favorites.map((item) {
            return ListTile(
              title: Text(item.asPascalCase, style: textStyle,)
            );
          }),
          context: context
        ).toList()
      )
    );
  }
}
