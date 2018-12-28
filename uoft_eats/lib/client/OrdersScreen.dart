import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uoft_eats/client/MainDrawer.dart';
import 'package:uoft_eats/client/clientGlobals.dart' as clientGlobals;
import 'ClientReceiptHeaders.dart';
import 'ClientFoodOrdered.dart';

class OrdersScreen extends StatefulWidget {
  OrdersScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OrdersScreenState createState() => new _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String user = clientGlobals.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text("Orders"),
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection("orders").where("client", isEqualTo: user)
                .where("status", isLessThan: 2).orderBy("status", descending: true).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                        return new Text('Loading...');
                    default:
                        return new ListView(
                            children:
                            snapshot.data.documents.map((DocumentSnapshot document) {
                                return orderWidget(document);
                            }).toList(),
                        );
                }
            }
        ),
    );
  }

  Widget orderWidget(DocumentSnapshot document) {
      int orderNum = document['orderNumber'];
      print('order num $orderNum');
      String foodTruck = document['server'];
      int status = document['status'];

      print('status $status');

      String statusStr = "";
      if (status == 0) {
          statusStr = "Order placed";
      } else if (status == 1) {
          statusStr = "Pick Up Now";
      }

      // need to take whats in the database an make it a list of lists
      // 0: quantity, 1: type, 2: size, 3: price
      List order = new List();
      double subtotal = 0.0;

      List databaseOrder = document['items'];
      for (int i = 0; i < databaseOrder.length; i++) {
          List subItems = new List();
          subItems.add(databaseOrder[i]['quantity']);
          subItems.add(databaseOrder[i]['type']);
          subItems.add(databaseOrder[i]['size']);
          subItems.add(databaseOrder[i]['price']);
          order.add(subItems);
          subtotal += subItems[0] * subItems[3];
      }

      return Padding(
          child: new Column(children: <Widget>[
              new Row(
                  children: <Widget>[
                      new Container(
                          child: new Text(
                              foodTruck,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                              ),
                          )
                      ),
                      new Spacer(),
                      new Text("Status: $statusStr"),
                      new Spacer(),
                      new Text("Order #$orderNum"),
                  ],
              ),
              ClientReceiptHeaders(),
              new Divider(color: Colors.blue),
              ClientFoodOrdered(order: order, subTotal: subtotal,),
          ],),
          padding: EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 0.0),
      );


  }
}
