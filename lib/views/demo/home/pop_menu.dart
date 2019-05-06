import 'package:flutter/material.dart';

enum PopMenuValues { demo, favorite, list }
typedef OnSelected (PopMenuValues v);

class PopMenu extends StatelessWidget {

  PopMenu({ this.onSelected, Key key }) : super(key: key);

  final OnSelected onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Icon(Icons.list),
      onSelected: onSelected,
      itemBuilder: (context) {
        return <PopupMenuEntry<PopMenuValues>>[
          const PopupMenuItem(
            value: PopMenuValues.favorite,
            child: Text('favorite'),
          ),
        ];
      },
    );
  }
}
