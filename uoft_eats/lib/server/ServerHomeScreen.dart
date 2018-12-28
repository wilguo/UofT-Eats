import 'package:flutter/material.dart';
import 'package:uoft_eats/server/ServerDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uoft_eats/server/serverGlobals.dart' as serverGlobals;

class ServerHomeScreen extends StatefulWidget {
  ServerHomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyServerHomeScreenState createState() => new _MyServerHomeScreenState();
}

class _MyServerHomeScreenState extends State<ServerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Welcome"), // widget.title
      ),
      drawer: ServerDrawer(),
      body: new StreamBuilder(
          stream: Firestore.instance.collection("servers").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(child: new Text('Error: ${snapshot.error}'));
            if (!snapshot.hasData)
              return Center(
                  child: const Text(
                    "Loading...",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ));
            DocumentSnapshot truckDoc;
            for (final document in snapshot.data.documents) {
              if (document.documentID == serverGlobals.user) {
                truckDoc = document;
                break;
              }
            }
            if (truckDoc == null) {
              print("the user: " + serverGlobals.user);
              return Center(
                child: new Text('Error: no such food truck.'));
            }
            return _buildPage(truckDoc);
          }
      ),
    );
  }


  Widget _buildPage(DocumentSnapshot document) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome, ",
            style: new TextStyle(fontSize: 38.0, color: Colors.black45),
          ),
          Text(document['name'],
            style: new TextStyle(
              fontSize: 48.0,
              color: Colors.black,
              fontWeight: FontWeight.w200)),
          Divider(
            color: Colors.black,
          ),
          Center(
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                  child: Text("Your hours today are: ",
                    style: new TextStyle(
                      fontSize: 20.0, color: Colors.black87)),
                ),
                Text(_formatHours(document),
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 48.0,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ]),
    );
  }

  String _formatHours(DocumentSnapshot document) {
    int weekday = DateTime.now().weekday;
    if (document['hours'][2 * weekday - 2] == -1) {
        return 'Closed Today';
    }

    String open = document['hours'][2 * weekday - 2].toString();
    String close = document['hours'][2 * weekday - 1].toString();

    int close_hour = int.parse(close.substring(0, close.length-2));
    String close_end = "";
    if (close_hour > 12) {
        close_hour = close_hour - 12;
        close_end = "pm";
    } else {
        close_end = "am";
    }

    int open_hour = int.parse(open.substring(0, open.length-2));

    String open_end = "";
    if (open_hour > 12) {
        open_hour = open_hour - 12;
        open_end = "pm";
    } else {
        open_end = "am";
    }

    String open2 = open_hour.toString() + ":" + open.substring(open.length-2, open.length) + open_end;
    String close2 = close_hour.toString() + ":" + close.substring(close.length-2, close.length) + close_end;

    return open2 + '\n-\n' + close2;
  }
}
