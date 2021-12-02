import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizapp/models/user.dart';
import 'package:quizapp/screens/all_answered_screen.dart';
import 'package:quizapp/screens/server_down_screen.dart';
import 'package:quizapp/screens/tabs_screen.dart';
import 'package:quizapp/screens/user_limit_screen.dart';
import 'package:quizapp/widgets/drawer.dart';
import './screens/questions_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(MyApp());
User player;
int max_players;
final FirebaseDatabase userDB = FirebaseDatabase.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser firebaseUser;
bool value = false;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laybrinth',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.amber,
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              body1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              body2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              title: TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCandensed',
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
       home: MyHomePage(title: 'Laybrinth '),

      routes: {
        QuestionsScreen.routeName: (ctx) => QuestionsScreen(),
        ServerDownScreen.routeName: (ctx) => ServerDownScreen(),
        AllAnsweredScreen.routeName: (ctx) => AllAnsweredScreen(),
        TabsScreen.routeName: (ctx) => TabsScreen(),
        UserLimitScreen.routeName: (ctx) => UserLimitScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
 setState(() {
                          value = true;
                        });
                        userDB
                            .reference()
                            .child('server')
                            .once()
                            .then((DataSnapshot snap) async {
                          ///
                          max_players = snap.value['status'];
                          if (max_players != 0) {
                            firebaseUser = await _gsignIn(context);
                            if (firebaseUser == null)
                              setState(() {
                                value = false;
                              });
                            //    Navigator.pushNamed(context, TabsScreen.routeName);
                          } else
                            Navigator.pushReplacementNamed(
                                context, ServerDownScreen.routeName);
                        });

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 300,
                width: 300,
                child: Image.asset(
                  'assets/images/icon.png',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                  'Hey there , to participate you need an existing gmail account'),
              SizedBox(
                height: 20,
              ),
             if( value == true) SpinKitCircle(
                      color: Theme.of(context).accentColor,
                      size: 100,
                    )
  
            ],
          ),
        ),
      ),
    );
  }
}

Future<FirebaseUser> _gsignIn(BuildContext context) async {
  GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  AuthResult result =
      await _auth.signInWithCredential(credential).whenComplete(() {
    value = false;
  });
  FirebaseUser user = result.user;
  if (user != null) {
    player = new User(
        email: user.email,
        passWord: 'googleuser',
        uId: user.uid,
        userName: user.displayName);

    userDB
        .reference()
        .child('user_data')
        .orderByKey()
        .equalTo(user.uid)
        .once()
        .then((data) {
      if (data.value == null) {
        userDB.reference().child('user_data').once().then((snap) {
          if (snap.value == null) {
            userDB.reference().child('user_data').child(user.uid).set({
              'uid': player.uId,
              'username': player.userName,
              'email': player.email,
              'password': player.passWord,
              'level': player.level,
              'date': DateTime.now().toString(),
            });
            Navigator.pushReplacementNamed(context, TabsScreen.routeName);
          } else {
            var keys = snap.value.keys;
            List<dynamic> _list = new List();
            for (var key in keys) {
              _list.add(key);
            }
            if (_list.length < max_players) {
              print("list: " +
                  _list.length.toString() +
                  "\n max: " +
                  max_players.toString());
              print('new user login..!');
              userDB.reference().child('user_data').child(user.uid).set({
                'uid': player.uId,
                'username': player.userName,
                'email': player.email,
                'password': player.passWord,
                'level': player.level,
                'date': DateTime.now().toString(),
              });
              Navigator.pushReplacementNamed(context, TabsScreen.routeName);
            } else {
              Navigator.pushReplacementNamed(
                  context, UserLimitScreen.routeName);
            }
          }
        });
      } else {
        print('Existing user loged in');
        userDB
            .reference()
            .child('user_data')
            .child(user.uid)
            .once()
            .then((data) {
          player.level = data.value['level'];
          Navigator.pushReplacementNamed(context, TabsScreen.routeName);
        });
      }
    });

    print('user is ${user.displayName}');

    //   Navigator.pushNamed(context, TabsScreen.routeName);
    return user;
  } else {
    Navigator.pushReplacementNamed(context, ServerDownScreen.routeName);
    return null;
  }
}
