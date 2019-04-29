import 'package:flutter/material.dart';

class InkWellButtonDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        splashColor: Colors.blue,
        onTap: () {
          print('666');
        },
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.orange[700]]
            ),
            borderRadius: BorderRadius.circular(3.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0
              )
            ]
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 18.0),
            child: Text('Button', style: TextStyle(color: Colors.white)),
          ),
        )
      )
    );
  }
}
