import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:uoft_eats/server/ServerDrawer.dart';
import 'ItemQuantityTile.dart';
import 'package:uoft_eats/server/serverGlobals.dart' as serverGlobals;

class QuantitiesOrderedScreen extends StatefulWidget {
  QuantitiesOrderedScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyQuantitiesOrderedScreenState createState() =>
      new _MyQuantitiesOrderedScreenState();
}

class _MyQuantitiesOrderedScreenState extends State<QuantitiesOrderedScreen> {
  static String server = serverGlobals.user;
  static List<ItemQuantityTile> itemQuantities = new List();

  @override
  Widget build(BuildContext context) {
    itemQuantities = new List();
    return new Scaffold(
        drawer: new ServerDrawer(),
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("orders").where("server", isEqualTo: server)
              .where("status", isEqualTo: 0).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default: {
                setListView(snapshot.data.documents);
                return new ListView.builder(
                  itemCount: itemQuantities.length,
                  itemBuilder: (BuildContext context, int index) {
                    return itemQuantities[index];
                  }
                );
              }
            }
          },
        ),
    );
  }

  void setListView(List<DocumentSnapshot> snapshots) {
    for (DocumentSnapshot document in snapshots) {
      for (Map map in document['items']) {
        bool found = false;
        for (ItemQuantityTile item in itemQuantities) {
          if (map['type'] == item.getTitle() && map['size'] == item.getSize()) {
            item.increaseQuantity(map['quantity']);
            found = true;
            break;
          }
        }
        if (!found) {
          ItemQuantityTile newMenuItem = ItemQuantityTile(map['type'], map['quantity'], map['size'], false);
          _MyQuantitiesOrderedScreenState.itemQuantities.add(newMenuItem);
        }
      }
    }
  }
}