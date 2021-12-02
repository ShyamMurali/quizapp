import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './all_answered_screen.dart';
import '../main.dart';

// final FirebaseUser _user = firebaseUser;
final answerContoller = TextEditingController();
bool state = true;
String answer;
int max_Q,maxpos;
String question =
    '(Error no question is being received please check your connectivity..)';
String image = 'none';
final DatabaseReference userDB = FirebaseDatabase.instance.reference();

class QuestionsScreen extends StatefulWidget {
  static const routeName = '/questions';
  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  @override
  void initState() {
    setState(() {
      state = true;
    });
    super.initState();
    print('Inintstate');

    userDB.child('max_questions').once().then((DataSnapshot data) {
      max_Q = data.value['value'];
      maxpos=max_Q+1;
      if (player.level > max_Q) {
        Navigator.pushReplacementNamed(context, AllAnsweredScreen.routeName);
      } else {
        userDB
            .child('questions')
            .child('${player.level}')
            .once()
            .then((DataSnapshot snap) {
          question = snap.value['title'];
          image = snap.value['image'];
          userDB
              .child('answers')
              .child('${player.level}')
              .once()
              .then((DataSnapshot snap) {
            answer = snap.value['answer'];
          });
          setState(() {
            state = false;
            answerContoller.clear(); // added here
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingQ() {
      return Container(
        child: Column(children: <Widget>[
          Text(
            'Loading Question......',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SpinKitPouringHourglass(
            duration: Duration(milliseconds: 2000),
            color: Colors.amber,
            size: 150,
          ),
          SizedBox(
            height: 30,
          )
        ]),
      );
    }

    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("current level:${player.level}"),
                      Text("Max Level: ${maxpos}"),
                    ],
                  ),
                  state
                      ? loadingQ()
                      : Column(
                          children: <Widget>[
                            Text('Q#${player.level}'),
                            if (image != 'none')
                              Container(
                                height: 400,
                                width: 300,
                                child: Image.network(
                                  image,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(question,style: TextStyle(fontWeight:FontWeight.bold),),
                            SizedBox(
                              height: 40,
                            ),
                            Text('place your answer down below'),
                            Text('(use lowercase letters or numbers)'),
                            SizedBox(height: 20),
                            TextField(
                              cursorColor: Theme.of(context).primaryColor,
                              controller: answerContoller,
                              decoration: InputDecoration(
                                labelText: 'Your Answer',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            RaisedButton(
                              onPressed: () {
                                if (answerContoller.text.isNotEmpty) {
                                  if (answerContoller.text == answer) {
                                    player.level++;
                                    userDB
                                        .child('user_data')
                                        .child(firebaseUser.uid)
                                        .update({
                                      'level': player.level,
                                      'date': DateTime.now().toString(),
                                    });
                                    answerContoller.clear(); // annded here
                                    setState(() {
                                      state = true;
                                    });

                                    userDB
                                        .child('max_questions')
                                        .once()
                                        .then((DataSnapshot data) {
                                      if (player.level > data.value['value']) {
                                        Navigator.pushReplacementNamed(context,
                                            AllAnsweredScreen.routeName);
                                      } else {
                                        userDB
                                            .child('questions')
                                            .child('${player.level}')
                                            .once()
                                            .then((DataSnapshot snap) {
                                          question = snap.value['title'];
                                          image = snap.value['image'];
                                          userDB
                                              .child('answers')
                                              .child('${player.level}')
                                              .once()
                                              .then((DataSnapshot snap) {
                                            answer = snap.value['answer'];
                                          });
                                          setState(() {
                                            state = false;
                                          });
                                        });
                                      }
                                    });
                                    // Navigator.pushNamed(context, CorrectAnswerScreen.routeName);
                                  } else {
                                    Fluttertoast.showToast(
                                    msg: 'Incorrect Answer !',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    backgroundColor: Colors.amber,
                                    textColor: Colors.black,
                                    fontSize: 15,
                                    timeInSecForIosWeb: 1,
                                    );
                                    //  Navigator.pushNamed(context, IncorrectAnswerScreen.routeName);
                                  }
                                }
                              },
                              child: Text(
                                'Submit Answer!',
                                style: Theme.of(context).textTheme.body2,
                              ),
                              color: Theme.of(context).accentColor,
                            ),
                          ],
                        ),
                ],
              )),
        ));
  }
}