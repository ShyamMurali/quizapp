import 'package:flutter/material.dart';
class ServerDownScreen extends StatelessWidget {
  static const routeName='/server-down';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Image.asset('assets/images/bugs_bunny_whisper.png'),
          Text('The app has been temporarly suspended by Admin,or there is an authenticaton error, try again after some time',
          style:TextStyle(fontSize: 30),),
          ],
        ),
      ),
    );
  }
}