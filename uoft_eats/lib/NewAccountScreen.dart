import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'server/serverGlobals.dart' as serverGlobals;
import 'client/clientGlobals.dart' as clientGlobals;

class NewAccountScreen extends StatefulWidget {
  final String title;

  NewAccountScreen({Key key, this.title}) : super(key: key);

  @override
  _MyNewAccountScreenState createState() => new _MyNewAccountScreenState();
}

class _MyNewAccountScreenState extends State<NewAccountScreen> {
  String dropdownValue = 'Student';

  final userController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

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
              'Create Account',
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
              child: new TextField(controller: userController,),
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
              margin: new EdgeInsets.only(top: 10.0),
              child: new Text('Repeat Password:'),
            ),
            new Container(
                margin: new EdgeInsets.only(bottom: 10.0),
                width: 200.0,
                child: new TextFormField(
                  controller: confirmPassController,
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
            new RaisedButton(
                onPressed: createAccount, child: new Text('Create Account')),
            new Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  void createAccount() async {
    String user = userController.text;
    String pass = Text(passController.text).data;
    String confirmPass = Text(confirmPassController.text).data;

    List<String> existingUsers = [];

    if (user == '') {
      Fluttertoast.showToast(
          msg: "Username cannot be empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2
      );
    } else if (pass == "") {
      Fluttertoast.showToast(
          msg: "Password cannot be empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2
      );
    } else if (pass != confirmPass) {
      Fluttertoast.showToast(
          msg: "Password does not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2
      );
    } else {
      Firestore fs = Firestore.instance;
      QuerySnapshot query = await fs.collection("accounts").getDocuments();
      List<DocumentSnapshot> docs = query.documents;

      for (int i = 0; i < docs.length; i++) {
        existingUsers.add(docs[i]['username']);
      }

      if (existingUsers.contains(user)) {
        Fluttertoast.showToast(
            msg: "Username taken",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2
        );
      } else {
        if (dropdownValue == 'Student') {
          clientGlobals.user = user;
          fs.collection('accounts').document()
              .setData({'username': user, 'password': pass, 'isStudent': true});

          fs.collection("clients").document(user).setData({"paymentEmail": "N/A"});

          Navigator.pushReplacementNamed(context, '/client/menus');
        } else {
          serverGlobals.user = user;
          fs.collection('accounts').document()
              .setData({'username': user, 'password': pass, 'isStudent': false});

          fs.collection("servers").document(user).setData({"paymentEmail": "N/A",
            "name": user, "hours": [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1, -1], "color": 0});
          
          Navigator.pushReplacementNamed(context, '/server/menus');
        }
      }
    }
  }

  Future<List<String>> getUsers() async {
    
    List<String> existingUsers = [];

    Firestore fs = Firestore.instance;
    Future<List<String>> ff = fs.collection("accounts").snapshots().listen((data) => (
        data.documents.forEach((doc) => (() {
          print(doc['username']);
          existingUsers.add(doc['username']);
        }))
    )).asFuture();

    return ff;
  }

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
}
