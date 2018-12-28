import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:uoft_eats/client/MainDrawer.dart';
import 'package:uoft_eats/client/clientGlobals.dart' as clientGlobals;

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PaymentScreenState createState() => new _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String user = clientGlobals.user;
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new MainDrawer(),
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Spacer(flex: 5),
            new Container(
              child: new Text(
                'Paypal Account Email:',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),
            new Container(
              margin: new EdgeInsets.all(10.0),
              child: _buildChild(),
            ),
            new Spacer(flex: 2),
            new Container(
              child: new Text(
                'Change PayPal Account',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),
            new Container(
              margin: new EdgeInsets.only(top: 10.0),
              child: new Text('Email Address for new Paypal Account:'),
            ),
            new Container(
              width: 200.0,
              child: new TextField(controller: emailController,),
            ),
            new Container(
              margin: new EdgeInsets.all(10.0),
              child: new RaisedButton(
                onPressed: _changeAccount,
                child: new Text('Change Account'),
              ),
            ),
            new Spacer(flex: 5)
          ],
        ),
      ),
    );
  }

  Widget _buildChild() {
    if (clientGlobals.user != null) {
      print(clientGlobals.user);
      return new StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection("clients").document(user).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              if (snapshot.data != null) {
                return new Text(snapshot.data["paymentEmail"]);
              } else {
                return new Text("NULL");
              }

          }
        },
      );
    } else {
      print("user: " + clientGlobals.user);
      return new Text("NULL");
    }
  }


  void _changeAccount() {
    String email = emailController.text;

    if (email == '') {
      Fluttertoast.showToast(
          msg: "Email cannot be empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2
      );
    } else {
      Firestore fs = Firestore.instance;
      fs.collection("clients").document(user).updateData({"paymentEmail": email});
    }

    emailController.text = "";
  }
}
