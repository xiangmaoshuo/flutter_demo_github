import 'package:flutter/material.dart';

class ContainerDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Center(
          child: Row(
            children: <Widget>[
              Image(image: AssetImage('lib/images/demo.jpg'), width: 100, height: 100, colorBlendMode: BlendMode.color, color: Colors.pink,),
              Image(image: AssetImage('lib/images/demo.jpg'), width: 100, height: 100, colorBlendMode: BlendMode.color, color: Colors.yellow,)
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(width: 5, color: Colors.black45),
          // color: Colors.yellow,
          // borderRadius: BorderRadius.all(Radius.circular(8)),
          // image: DecorationImage(image: AssetImage('lib/images/demo.jpg'), fit: BoxFit.contain),
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: <Color>[Colors.pink, Colors.amber])
        ),
    );
  }
}
