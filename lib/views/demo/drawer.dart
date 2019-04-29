import 'package:flutter/material.dart';

class DrawerDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Drawer(
          child: MediaQuery.removePadding(
            removeLeft: true,
            removeTop: true,
            context: context,
            child: Center(
              child: ClipOval(
                child: Image.asset('lib/images/demo.jpg',width: 80,),
              ),
            ),
          ),
        );
      },
    );
  }
}
