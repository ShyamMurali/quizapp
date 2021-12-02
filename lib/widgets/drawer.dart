import 'package:flutter/material.dart';
class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Drawer(
        child: Container(
          margin: EdgeInsets.only(top:50,bottom: 10,left: 10,right: 10 ),
          padding: EdgeInsets.all(10),
          child: Text('Hello User , if you  find any bugs please report to quiztimeone @gmail.com')),
      );
  }
}