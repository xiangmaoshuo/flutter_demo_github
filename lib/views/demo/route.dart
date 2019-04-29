import 'package:flutter/material.dart';

class RouteDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        onPressed: () async {
          final res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _NextRoute())
          );
          if(res != null) Scaffold.of(context).showSnackBar(SnackBar(content: Text(res),));
        },
        child: Text('跳转到下个路由', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}

class _NextRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context, '来自_NextRoute widget 的信息');
          },
          child: Text('点我返回上个页面，并传递参数')
        )
      ),
      appBar: AppBar(
        title: Text('路由传参demo页面'),
      ),
    );
  }
}

