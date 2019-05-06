import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import '../../../tools/event_bus.dart';
import 'dart:math' as math;
import 'favorite.dart';
import 'pop_menu.dart';
import '../index.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() {
    return new _HomeState();
  }
}

class _HomeState extends State<Home> {
  final _suggestions = <WordPair>[];
  final textStyle = const TextStyle(fontSize: 18.0);
  final favorites = new Set<WordPair>();

  // 跳转到favorite列表
  _pushSaved () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Favorite(favorites, textStyle);
        }
      )
    );
  }

  _pushDemo () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Demo();
        }
      )
    );
  }


  // 点击右上角按钮后的回调
  onSelected(v) {
    switch (v) {
      case PopMenuValues.demo:
        _pushDemo();
        break;
      case PopMenuValues.favorite:
        _pushSaved();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
        actions: <Widget>[
          PopMenu(onSelected: onSelected),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ListView.builder(
            itemBuilder: (context, i) {
              if (i.isOdd) return Divider(color: theme.primaryColor);
              final index = i ~/2;
              if (index >= _suggestions.length) {
                
                _suggestions.addAll(generateWordPairs().take(index - _suggestions.length + 1));
              }
              return _ListItem(item: _suggestions[index], textStyle: textStyle, favorites: favorites);
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.color_lens), onPressed: () {
        bus.emit('changeTheme', Colors.primaries[math.Random().nextInt(Colors.primaries.length)]);
      },),
    );
  }
}

class _ListItem extends StatefulWidget {
  final item;
  final textStyle;
  final favorites;
  _ListItem({Key key, this.item, this.textStyle, this.favorites}): super(key: key);
  @override
  State<_ListItem> createState() {
    return new _ListItemState();
  }
}

class _ListItemState extends State<_ListItem> {
  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final textStyle = widget.textStyle;
    final favorites = widget.favorites;
    final ThemeData theme = Theme.of(context);
    return ListTile(
      title: new Text(item.asPascalCase,  style: textStyle),
      trailing: Icon(favorites.contains(item) ? Icons.favorite : Icons.favorite_border, color: theme.primaryColor,),
      onTap: () {
        setState(() {
          favorites.contains(item) ? favorites.remove(item) : favorites.add(item); 
        });
      },
    );
  }
}

