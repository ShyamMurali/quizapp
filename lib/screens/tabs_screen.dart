import 'package:flutter/material.dart';
import 'package:quizapp/screens/leaderboards.dart';
import 'package:quizapp/screens/questions_screen.dart';
import 'package:quizapp/widgets/drawer.dart';


class TabsScreen extends StatefulWidget {
  static const routeName='/tabs-screen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final  List<Map<String,Object>> pages=[
   {  
       'page':QuestionsScreen(),
       'title':'Questions'
   },
   {   'page':LeaderBoards(),
        'title':'Leaderboards'

   }
  ];
  int _selectedPageIndex =0;
  void _selectPage(int index){
   setState(() {
     _selectedPageIndex =index;
   });
  }
  @override
  Widget build(BuildContext context) {
      
      return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text(pages[_selectedPageIndex]['title']),
        ),
        body:pages[_selectedPageIndex]['page'],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          unselectedItemColor: Colors.white,
          currentIndex: _selectedPageIndex,
          selectedItemColor: Theme.of(context).accentColor,
          backgroundColor:Theme.of(context).primaryColor,
          items: [ 
            BottomNavigationBarItem(icon: Icon(Icons.question_answer),
            title: Text('Questions'),
            ),
            BottomNavigationBarItem(icon: Icon(Icons.list),
            title: Text('LeaderBoards'),
            ),
          ],),
      );
 

  
  }
}