import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:uoft_eats/client/MainDrawer.dart';
import 'package:uoft_eats/client/TemplateMenuScreen.dart';

class MenusScreen extends StatefulWidget {
  MenusScreen({Key key, this.title, this.user}) : super(key: key);

  final String user;
  final String title;

  @override
  _MyMenusScreenState createState() => new _MyMenusScreenState();
}

class _MyMenusScreenState extends State<MenusScreen> {
  int weekday = DateTime.now().weekday;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("servers").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return new ListTile(
                    leading: Icon(
                      Icons.restaurant,
                      // See https://docs.flutter.io/flutter/material/Colors-class.html
                      color: Color(document['color']),
                    ),
                    title: Text(document['name']),
                    subtitle: _formatHours(document),
                    onTap: () {
                      _accessMenu(document);
                    },
                  );
                }).toList(),
              );
          }
        },
      ),
      drawer: MainDrawer(),
    );
  }

  // Refer to the formulas below for accessing the open/close times of the day
  // Note: opening hour of a day is set to 1 ==> truck is closed that day
  Text _formatHours(DocumentSnapshot document) {
    if (document['hours'][2 * weekday - 2] == -1) return Text('Closed Today');
    return Text('Open ' +
        document['hours'][2 * weekday - 2].toString() +
        ' - ' +
        document['hours'][2 * weekday - 1].toString());
  }

  void _accessMenu(DocumentSnapshot document) {
    if (document['hours'][2 * weekday - 2] == -1) {
      Fluttertoast.showToast(
          msg: "This Food Truck is Closed!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TemplateMenuScreen(
                    title: "Template Menu",
                    name: document['name'],
                    color: document['color'],
                    truck: document.documentID,
                    menuStream: Firestore.instance
                        .collection('servers/' + document.documentID + '/menu')
                        .snapshots(),
                  )));
    }
  }
}
