import 'package:flutter/material.dart';
import 'package:uoft_eats/server/ServerDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uoft_eats/server/serverGlobals.dart' as serverGlobals;

class ServerOrderHistory extends StatefulWidget {
  ServerOrderHistory({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ServerOrderHistoryState createState() => new _ServerOrderHistoryState();
}

class _ServerOrderHistoryState extends State<ServerOrderHistory> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: new ServerDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "BY DATE"),
              Tab(text: "BY QUANTITY"),
            ],
          ),
          title: Text("ORDER HISTORY"),
        ),
        body: TabBarView(
          children: [OrderByTime(), OrderByQuantity()],
        ),
      ),
    );
  }
}

class OrderByTime extends StatelessWidget {
  Widget _buildOrderCard(BuildContext context, DocumentSnapshot document) {
    List items = document['items'];
    double subtotal = 0.0;
    StringBuffer order = new StringBuffer();
    for (final item in items) {
      StringBuffer name = new StringBuffer();
      name.write(item['quantity'].toString() + ' x ');
      if (item['size'] != '-1') {
        name.write(item['size'].toString() + ' ');
      }
      name.write(item['type'].toString() + '\n');
      order.write(name.toString());
      subtotal += item['price'] * item['quantity'];
    }
    return OrderCard(
      name: document['client'],
      subtotal: subtotal.toString(),
      orderContents: order.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: const Text(
            "Loading...",
            style: TextStyle(fontWeight: FontWeight.bold),
          ));
        List documents = [];
        for (final document in snapshot.data.documents) {
          if (document['status'].toString() == '2' &&
              document['server'] == serverGlobals.user) {
            documents.add(document);
          }
        }
        return new ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return _buildOrderCard(context, documents[index]);
          },
        );
      },
    );
  }
}

class OrderByQuantity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: const Text(
            "Loading...",
            style: TextStyle(fontWeight: FontWeight.bold),
          ));
        }
        List<DocumentSnapshot> documents = [];
        for (final document in snapshot.data.documents) {
          if (document['status'].toString() == '2' &&
              document['server'] == serverGlobals.user) {
            documents.add(document);
          }
        }
        Map<String, int> map = new Map();
        for (final document in documents) {
          for (final item in document['items']) {
            StringBuffer nameBuffer = new StringBuffer('');
            if (item['size'] != '-1') {
              nameBuffer.write(item['size'].toString() + ' ');
            }
            nameBuffer.write(item['type']);
            String name = nameBuffer.toString();
            map.putIfAbsent(name, () => 0);
            map[name] += item['quantity'];
          }
        }
        return new ListView.builder(
          itemCount: map.length,
          itemBuilder: (context, index) {
            String name = map.keys.toList()[index];
            int quantity = map[name];
            return new QuantityCard(
              name: name,
              quantity: quantity,
            );
          },
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final String name;
  final String subtotal;
  final String orderContents;

  OrderCard({Key key, this.name, this.subtotal, this.orderContents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
      child: ListTile(
        leading: Icon(Icons.check_circle_outline),
        title: Text("$name",
            style: new TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
        subtitle: Text("Subtotal: \$$subtotal\n$orderContents"),
      ),
    );
  }
}

class QuantityCard extends StatelessWidget {
  final String name;
  final int quantity;

  const QuantityCard({Key key, this.name, this.quantity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.all(20.0),
            child: new Row(children: <Widget>[
              // Icon
              Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Text("$quantity",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 48.0))),
              // Order
              Container(
                width: 220.0,
                padding: const EdgeInsets.only(right: 5.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Name
                    Text("$name", style: new TextStyle(fontSize: 26.0)),
                  ],
                ),
              ),
            ])),
      ],
    ));
  }
}
