import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;

import 'views/demo/index.dart';
import 'tools/event_bus.dart';
import 'bloc/index.dart' show BlocProviderTree, BlocProvider, StateDispatchBloc;
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  MaterialColor themeColor = Colors.pink;
  @override
  void initState() {
    super.initState();
    bus.on('changeTheme', (color) {
      setState(() {
        themeColor = color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '天歌',
      home: BlocProviderTree(
        blocProviders: [
          BlocProvider<StateDispatchBloc<List<String>>>(builder: (context) => new StateDispatchBloc<List<String>>([]))
        ],
        child: new Demo(),
      ),
      debugShowCheckedModeBanner: !bool.fromEnvironment('dart.vm.product'),
      theme: ThemeData(
        primarySwatch: themeColor,
        bottomAppBarTheme: BottomAppBarTheme(color: themeColor)
      ),
    );
  }
}



// 开始渲染app
void main() => SystemChrome.setPreferredOrientations(
  [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
).then((v) => runApp(new MyApp()));

/// setState 和 InheritedWidget 都能触发ui的重新渲染，他们之间有关系，也有区别。
/// 关系就在于InheritedWidget想要触发更新，得通过setState来调取父Widget的rebuild方法，生成一个新的InheritedWidget，然后InheritedWidget.updateShouldNotify通过对比是否改变，
/// 最后再通知依赖于它的widget重新渲染
/// 区别也是显而易见的，setState会重新build整个子树，所以一般情况下，setState就已经可以满足ui视图更新这个功能，但是在flutter的diff过程中，如果oldWidget == newWidget，这中情况
/// flutter会直接跳过该子Widget的，这时候InheritedWidget便派上用场了。
/// 另外需要注意的是，flutter和js一样，都有基本类型和引用类型，当依赖的数据是引用类型时，有可能不会触发依赖的更新，此时如果ui更新了的化，则是setState的功劳了
/// 以下为一个例子：

// class A extends StatefulWidget {
//   @override
//   State<A> createState() {
//     return new _AState();
//   }
// }

// class _AState extends State<A> {
//   int items = 333;
//   final B childB = B();
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Column(
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(top: 20),
//           ),
//           RaisedButton(
//             child: Text('点我改变List',),
//             onPressed: () {
//               setState(() {
//                items = 444;
//               });
//             },
//           ),
//           Divider(color: Colors.pink,),
//           _ShareDataWidget(
//             child: B(),
//             items: items,
//           )
//         ],
//       ),
//     );
//   }
// }

// class B extends StatefulWidget {
//   @override
//   State<B> createState() {
//     return new _BState();
//   }
// }

// class _BState extends State<B> {
//   _ShareDataWidget store;

//   @override
//   void didChangeDependencies() {
//     print('2333333333');
//     store ??= _ShareDataWidget.of(context);
//     super.didChangeDependencies();
//   }
//   @override
//   Widget build(BuildContext context) {
//     print(1111);
//     return Text('${store.items}');
//   }
// }




// // 声明一个上下文widget，以方便传递数据
// class _ShareDataWidget extends InheritedWidget {
//   final int items;
//   _ShareDataWidget({
//     @required Widget child,
//     @required this.items,
//   }): assert(child != null),
//       super(child: child);

//   static _ShareDataWidget of (BuildContext context) {
//     return context.inheritFromWidgetOfExactType(_ShareDataWidget);
//   }

//   @override
//   bool updateShouldNotify(_ShareDataWidget oldWidget) {
//     print('updateShouldNotify, ${oldWidget.items}');
//     print('updateShouldNotify, ${items}');
//     print(oldWidget.items != items);
//     return oldWidget.items != items;
//   }
// }