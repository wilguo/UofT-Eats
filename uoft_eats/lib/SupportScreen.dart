import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  final String title;

  SupportScreen({Key key, this.title}) : super(key: key);

  @override
  _MySupportScreenState createState() => new _MySupportScreenState();
}

class _MySupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //new Spacer(flex: 1),
            new Container(
                margin: new EdgeInsets.only(top: 150.0),
                child: new Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            new Spacer(flex: 1),
            new Container(
              margin: new EdgeInsets.only(top: 25.0),
              child: new Text('Email:'),
            ),
            new Container(width: 300.0, child: new TextField()),
            new Container(
                child: new RaisedButton(
                    child: new Text('Send Email'),
                    onPressed: () {
                      _alertEmailSent(context);
                    })),
            new Spacer(flex: 5),
          ],
        ),
      ),
    );
  }
}

Future<bool> _alertEmailSent(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Password reset email sent.'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Back to Login'),
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
