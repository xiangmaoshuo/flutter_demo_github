import 'package:flutter/material.dart';

class HeroDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: #head,
      child: Material(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: ClipOval(
              child: Image.asset('lib/images/launch_background.png', fit: BoxFit.fitWidth, width: 300, height: 300,),
            ),
          ),
        ),
      ),
    );
  }
}
