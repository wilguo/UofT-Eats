import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'server/serverGlobals.dart' as serverGlobals;
import 'client/clientGlobals.dart' as clientGlobals;
import 'client/MenusScreen.dart';

class LoginScreen extends StatefulWidget {
  final String title;

  LoginScreen({Key key, this.title}) : super(key: key);

  @override
  _MyLoginScreenState createState() => new _MyLoginScreenState();
}

class _MyLoginScreenState extends State<LoginScreen> {
  String dropdownValue = 'Student';

  final userController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Spacer(flex: 3),
            new Container(
                child: new Text(
              'U of T Eats',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            )),
            new Spacer(flex: 1),
            new Container(
              margin: new EdgeInsets.only(top: 10.0),
              child: new Text('Username:'),
            ),
            new Container(
              margin: new EdgeInsets.only(bottom: 10.0),
              width: 200.0,
              child: new TextFormField(
                controller: userController,
              ),
            ),
            new Container(
              margin: new EdgeInsets.only(top: 10.0),
              child: new Text('Password:'),
            ),
            new Container(
                margin: new EdgeInsets.only(bottom: 10.0),
                width: 200.0,
                child: new TextFormField(
                  controller: passController,
                  obscureText: true,
                )),
            new Container(
                margin: new EdgeInsets.all(5.0),
                height: 50.0,
                child: new DropdownButton<String>(
                    value: dropdownValue,
                    items:
                        <String>['Student', 'Food Truck'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (String _value) {
                      setState(() {
                        dropdownValue = _value;
                      });
                    })),
            new RaisedButton(onPressed: _login, child: new Text('Login')),
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    margin: new EdgeInsets.all(5.0),
                    child: new RaisedButton(
                      onPressed: _createAccount,
                      child: new Text('Create Account'),
                    ),
                  ),
                  new Container(
                    margin: new EdgeInsets.all(5.0),
                    child: new RaisedButton(
                      onPressed: _support,
                      child: new Text('Support'),
                    ),
                  ),
                ]),
            new Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  void _login() async {
    String user = userController.text;
    String pass = Text(passController.text).data;

    bool isStudent = false;
    if (dropdownValue == 'Student') {
      isStudent = true;
    }

    Firestore fs = Firestore.instance;
    QuerySnapshot query = await fs.collection("accounts").getDocuments();
    List<DocumentSnapshot> docs = query.documents;

    bool myLogged = false;

    for (int i = 0; i < docs.length; i++) {
      if (docs[i]['username'] == user && docs[i]['password'] == pass &&
          docs[i]['isStudent'] == isStudent) {
        if (isStudent) {
          myLogged = true;
          clientGlobals.user = user;
          print(clientGlobals.user);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MenusScreen(
                      title: 'Menus',
                      user: user,
                  )));
        } else {
          myLogged = true;
          serverGlobals.user = user;
          Navigator.pushReplacementNamed(context, '/server');
        }
      }
    }

    if(!myLogged){
      Fluttertoast.showToast(
        msg: "Invalid Login",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2
      );
    }
  }

  void _support() {
    Navigator.pushNamed(context, '/support');
  }

  void _createAccount() {
    Navigator.pushNamed(context, '/newAccount');
  }
}
