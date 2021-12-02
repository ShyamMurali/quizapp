import 'package:flutter/material.dart';
class UserLimitScreen extends StatelessWidget {
  static const routeName='/user_limit';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maximum User Limit Reached !'),
      ),
      body: Center(
        child: Container(
          margin:const EdgeInsets.all(20),
          child: Text('For the proper working of the app ,the total amount of users has been currently limited,we are sorry for the inconvinence',
          style: TextStyle(fontSize: 20), ),
        ),
      ),
    );
  }
}