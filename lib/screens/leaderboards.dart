import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
DatabaseReference dbRef=FirebaseDatabase.instance.reference().child('user_data');
List<dynamic> lists= new List();
class LeaderBoards extends StatefulWidget {
  @override
  _LeaderBoardsState createState() => _LeaderBoardsState();
}

class _LeaderBoardsState extends State<LeaderBoards> {
  @override
  void initState() {
    super.initState();
    print('initstate leaderboards');
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: dbRef.once(),
    builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.hasData) {
        lists.clear();
        Map<dynamic, dynamic> values = snapshot.data.value;
        values.forEach((key, values) {
            lists.add(values);
            lists.sort((b,a){
              return a['level']==b['level']?
              b['date'].compareTo(a['date'])
              :a['level'].compareTo(b['level']);
            }
            ); 
        });
        return new ListView.builder(
            shrinkWrap: true,
            itemCount: lists.length,
            itemBuilder: (BuildContext context, int index) {
               

               if(index ==0){
              return Card(
                     margin: EdgeInsets.symmetric(vertical: 8,
                     horizontal: 5), 
                     elevation: 5,
                    child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromRGBO(255, 215, 0, 1),
                      foregroundColor: Colors.black,
                      radius: 20,
                      child: Text('#'+(index+1).toString()),
                    ),  
                    title: Text(lists[index]["username"]),
                    subtitle: Text(lists[index]["email"]),
                    trailing: Text('current level: '+ lists[index]["level"].toString()),
                  ),
                );
               }

             else  if(index == 1){
              return Card(
                     margin: EdgeInsets.symmetric(vertical: 8,
                     horizontal: 5), 
                     elevation: 5,
                    child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromRGBO(192, 192, 192, 1),
                      foregroundColor: Colors.black,
                      radius: 20,
                      child: Text('#'+(index+1).toString()),
                    ),  
                    title: Text(lists[index]["username"]),
                    subtitle: Text(lists[index]["email"]),
                    trailing: Text('current level: '+ lists[index]["level"].toString()),
                  ),
                );
               }

                  else  if(index == 2){
              return Card(
                     margin: EdgeInsets.symmetric(vertical: 8,
                     horizontal: 5), 
                     elevation: 5,
                    child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromRGBO(205, 127, 50, 1),
                      foregroundColor: Colors.black,
                      radius: 20,
                      child: Text('#'+(index+1).toString()),
                    ),  
                    title: Text(lists[index]["username"]),
                    subtitle: Text(lists[index]["email"]),
                    trailing: Text('current level: '+ lists[index]["level"].toString()),
                  ),
                );
               }
               
                  else  if(index >2 && index <=9 ){
              return Card(
                     margin: EdgeInsets.symmetric(vertical: 8,
                     horizontal: 5), 
                     elevation: 5,
                    child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[400],
                      foregroundColor: Colors.black,
                      radius: 20,
                      child: Text('#'+(index+1).toString()),
                    ),  
                    title: Text(lists[index]["username"]),
                    subtitle: Text(lists[index]["email"]),
                    trailing: Text('current level: '+ lists[index]["level"].toString()),
                  ),
                );
               }

                  else  if(index >=10 && index <=19 ){
              return Card(
                     margin: EdgeInsets.symmetric(vertical: 8,
                     horizontal: 5), 
                     elevation: 5,
                    child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromRGBO(64, 186, 213, 1),
                      foregroundColor: Colors.white,
                      radius: 20,
                      child: Text('#'+(index+1).toString()),
                    ),  
                    title: Text(lists[index]["username"]),
                    subtitle: Text(lists[index]["email"]),
                    trailing: Text('current level: '+ lists[index]["level"].toString()),
                  ),
                );
               }
               else{
                return Card(
                     margin: EdgeInsets.symmetric(vertical: 8,
                     horizontal: 5), 
                     elevation: 5,
                    child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromRGBO(48, 71, 94, 1),
                      foregroundColor: Colors.white,
                      radius: 20,
                      child: Text('#'+(index+1).toString()),
                    ),  
                    title: Text(lists[index]["username"]),
                    subtitle: Text(lists[index]["email"]),
                    trailing: Text('current level: '+ lists[index]["level"].toString()),
                  ),
                );
               }
            });
        }
        return Center(
          child: SpinKitCubeGrid(
            color: Theme.of(context).accentColor,
            size: 150,),
        );
    });
  }
}