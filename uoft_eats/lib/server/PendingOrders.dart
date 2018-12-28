import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:uoft_eats/server/ServerDrawer.dart';
import 'ReceiptHeaders.dart';
import 'FoodOrdered.dart';

class PendingOrders extends StatefulWidget {
  final Map<int, Tuple2<String, Map<String, List>>> customerOrders;
  final Map<int, Tuple2<String, Map<String, List>>> customerPickup;
  final double taxPercent;
  AsyncSnapshot<QuerySnapshot> snapshot1;
  AsyncSnapshot<QuerySnapshot> snapshot2;
  PendingOrders(
      {Key key,
      this.customerOrders,
      this.customerPickup,
      this.taxPercent,
      this.snapshot1,
      this.snapshot2})
      : super(key: key);

  @override
  _PendingOrders createState() => new _PendingOrders();
}

class _PendingOrders extends State<PendingOrders> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Pending Orders"),
        ),
        drawer: ServerDrawer(),
        body: OrderBody(
          customerOrders: widget.customerOrders,
          customerPickup: widget.customerPickup,
          taxPercent: widget.taxPercent,
          snapshot1: widget.snapshot1,
          snapshot2: widget.snapshot2,
        ));
  }
}

class OrderBody extends StatefulWidget {
  final Map<int, Tuple2<String, Map<String, List>>> customerOrders;
  final Map<int, Tuple2<String, Map<String, List>>> customerPickup;
  double taxPercent;
  AsyncSnapshot<QuerySnapshot> snapshot1;
  AsyncSnapshot<QuerySnapshot> snapshot2;

  OrderBody(
      {this.customerOrders,
      this.customerPickup,
      this.taxPercent,
      this.snapshot1,
      this.snapshot2});

  @override
  State<StatefulWidget> createState() {
    return _OrderBodyState();
  }
}

class _OrderBodyState extends State<OrderBody> {
  //Map<int, Tuple2<String, Map<String, List>>> customerOrders;

  void _completeOrder(int order) {
    for (int i = 0; i < widget.snapshot1.data.documents.length; i++) {
      if (widget.snapshot1.data.documents[i]['orderNumber'] == order) {
        var documentID = widget.snapshot1.data.documents[i].documentID;
        Firestore.instance
            .collection('orders')
            .document(documentID)
            .updateData({'status': 1});
      }
    }

    Navigator.pushReplacementNamed(context, '/server/orders');
  }

  void _pickupOrder(int order) {
    for (int i = 0; i < widget.snapshot2.data.documents.length; i++) {
      if (widget.snapshot2.data.documents[i]['orderNumber'] == order) {
        var documentID = widget.snapshot2.data.documents[i].documentID;
        Firestore.instance
            .collection('orders')
            .document(documentID)
            .updateData({'status': 2});
      }
    }

    Navigator.pushReplacementNamed(context, '/server/orders');
  }

  List<Widget> _getPendingOrders() {
    List<int> orderNumbers = widget.customerOrders.keys.toList();
    orderNumbers.sort();

    List<Widget> fullList = new List<Widget>();

    fullList.add(
      new Text("Pending:",
          style: new TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline)),
    );

    if (orderNumbers.isEmpty) {
      fullList.add(new Container(
          padding: new EdgeInsets.all(5.0),
          child: new Text("** No Pending Orders **",
              style: new TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.red))));
    }

    for (int order in orderNumbers) {
      Tuple2<String, Map<String, List>> singleOrder =
          widget.customerOrders[order];
      String customerName = singleOrder.item1;
      Map<String, List> customerOrder = singleOrder.item2;

      fullList.add(new Column(children: <Widget>[
        new Align(
            alignment: Alignment.topRight,
            child: new Text("Order#" + order.toString(),
                style: new TextStyle(fontSize: 16.0))),
        new Align(
          alignment: Alignment.topLeft,
          child: new Text("Customer: " + customerName.toString(),
              style:
                  new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        ),
        ReceiptHeaders(),
        new Divider(color: Colors.blue),
        FoodOrdered(order: customerOrder, taxPercent: widget.taxPercent),
        new RaisedButton(
            child: new Text("Order#" + order.toString() + " Completed"),
            onPressed: () {
              _completeOrder(order);
            }),
        new Divider(color: Colors.black87),
        new SizedBox(
          height: 12.0,
        )
      ]));
    }
    return fullList;
  }

  List<Widget> _getCompletedOrders() {
    List<int> orderNumbers = widget.customerPickup.keys.toList();
    orderNumbers.sort();

    List<Widget> fullList = new List<Widget>();

    fullList.add(new Container(
      margin: new EdgeInsets.all(3.0),
      child: new Text("Pickup:",
          style: new TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline)),
    ));

    if (orderNumbers.isEmpty) {
      fullList.add(new Container(
          padding: new EdgeInsets.all(5.0),
          child: new Text("** No orders to be picked up **",
              style: new TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.red))));
    }

    for (int order in orderNumbers) {
      Tuple2<String, Map<String, List>> singleOrder =
          widget.customerPickup[order];
      String customerName = singleOrder.item1;
      Map<String, List> customerOrder = singleOrder.item2;

      fullList.add(new Column(children: <Widget>[
        new Align(
            alignment: Alignment.topRight,
            child: new Text("Order#" + order.toString(),
                style: new TextStyle(fontSize: 16.0))),
        new Align(
          alignment: Alignment.topLeft,
          child: new Text("Customer: " + customerName.toString(),
              style:
                  new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        ),
        ReceiptHeaders(),
        new Divider(color: Colors.blue),
        FoodOrdered(order: customerOrder, taxPercent: widget.taxPercent),
        new RaisedButton(
            child: new Text("Order#" + order.toString() + " Picked up"),
            onPressed: () {
              _pickupOrder(order);
            }),
        new Divider(color: Colors.black87),
        new SizedBox(
          height: 12.0,
        )
      ]));
    }
    return fullList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: new EdgeInsets.all(10.0),
        child: new ListView(children: <Widget>[
          new Container(
              padding: new EdgeInsets.all(8.0),
              color: Colors.amberAccent,
              child: new Column(children: _getPendingOrders())),
          new Container(
              padding: new EdgeInsets.all(8.0),
              color: Colors.lime,
              child: new Column(children: _getCompletedOrders()))
        ]));
  }
}
