import 'package:flutter/material.dart';
import 'package:quizapp/screens/leaderboards.dart';

class AllAnsweredScreen extends StatelessWidget {
  static const routeName='/all-answered';
  @override
  Widget build(BuildContext context) {
   final appbar=AppBar(title: Text('Congrats Cheif'),);

    final mediaQuery=MediaQuery.of(context);
    final aheight=mediaQuery.size.height-appbar.preferredSize.height- mediaQuery.padding.top-10;
    return Scaffold(
      appBar:appbar, 
      body: Container(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: aheight*.30,
              child: FittedBox(
                              child: Column(
                  children: <Widget>[
                    Image.asset('assets/images/peak.png',
                    fit: BoxFit.cover,),
                ],
                ),
              )),
              Container(
                padding: EdgeInsets.all(10),
                height: aheight*.20,
              child: FittedBox(
                              child: Column(
                  children: <Widget>[
                    FittedBox(
                     child: Text('Wow cheif seems like you  have answered all the questions....\n wow you are amazing..',
            style: TextStyle(fontSize: 15),),
                    ),
            Text('Take a look at the LeaderBoards'),
                  ],
                ),
              ),
              ),
            Container(
              height: aheight*.5,
              child: LeaderBoards()),

          ],
          ),
      ),
    );
  }
}