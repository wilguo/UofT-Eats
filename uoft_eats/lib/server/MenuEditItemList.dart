import 'package:flutter/material.dart';
import 'package:uoft_eats/server/ServerDrawer.dart';
import 'MenuItemEdit.dart';
import 'MenuAddItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uoft_eats/server/serverGlobals.dart' as serverGlobals;

void main() => runApp(new MenuEditItemList());

class MenuEditItemList extends StatefulWidget {
  MenuEditItemList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MenuEditItemListState createState() => new _MenuEditItemListState();
}

class _MenuEditItemListState extends State<MenuEditItemList> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new ServerDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.fastfood),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                    (MenuAddItem(isFood: true))),
              );
            },
          ),
          new IconButton(
            icon: Icon(Icons.local_drink),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                    (MenuAddItem(isFood: false))),
              );
            }
          ),
        ],
      ),
      body: new StreamBuilder(
        stream: Firestore.instance.collection('servers').snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return Center(child: new Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData)
            return Center(
                child: const Text(
              "Loading...",
              style: TextStyle(fontWeight: FontWeight.bold),
            ));
          String name = serverGlobals.user;
          DocumentSnapshot truckDoc;
          for (final document in snapshot.data.documents) {
            if (document.documentID == name) {
              truckDoc = document;
              break;
            }
          }
          if (truckDoc == null) {
            return Center(
                child: new Text('Error: no such food truck $name.'));
          }
          Stream<QuerySnapshot> menuStream = Firestore.instance
            .collection('servers/' + name + '/menu')
            .snapshots();
          return _generateCards(menuStream);
        }));
  }

  Widget _generateCards(Stream<QuerySnapshot> menuStream) {
    return new StreamBuilder(
      stream: menuStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return _buildItemCard(document);
              }).toList(),
            );
        }
      },
    );
  }

  Widget _buildItemCard(DocumentSnapshot document) {
    return new EditableMenuItem(
      name: document['name'],
      price: Map.from(document['pricing']),
    );
  }
}

class EditableMenuItem extends StatelessWidget {
  final String name;
  final Map<String, dynamic> price;

  EditableMenuItem({Key key, this.name, this.price}) : super(key: key);

  Widget build(BuildContext context) {
    return new Container(
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text("$name",
                  style:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.edit,
                ),
                tooltip: 'Edit this item',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                        (MenuItemEdit(name: name, price: price))),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
