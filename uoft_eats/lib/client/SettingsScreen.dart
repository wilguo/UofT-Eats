import 'package:flutter/material.dart';

import 'package:uoft_eats/client/MainDrawer.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsScreenState createState() => new _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: new MainDrawer(),
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text(
                'PLACEHOLDER',
              ),
            ],
          ),
        ));
  }
}
