import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uoft_eats/server/serverGlobals.dart' as serverGlobals;

import 'PendingOrders.dart';

class ServerOrdersScreen extends StatefulWidget {
  ServerOrdersScreen({Key key, this.title, this.name}) : super(key: key);
  final String title;
  final String name;
  static final double taxPercent = 0.13;
  // key is the order number.
  /* static final Map<int, Tuple2<String, Map<String, List>>> customerOrders = {
    215: new Tuple2<String, Map<String, List>>("Anna", {
      "Poutine": ["M", 1, 5.00],
      "Hot Dog": ["S", 1, 2.50],
      "Water": ["N/A", 1, 1.00]
    }),
    216: new Tuple2<String, Map<String, List>>("Kara", {
      "Cheeseburger": ["N/A", 1, 5.00],
      "Soda": ["N/A", 2, 2.00]
    }),
    218: new Tuple2<String, Map<String, List>>("Jordan", {
      "Hamburger and Fries": ["S", 1, 5.50],
      "Soda": ["N/A", 1, 2.00]
    }),
    219: new Tuple2<String, Map<String, List>>("Wilbert", {
      "Bacon Poutine": ["L", 1, 7.50]
    }),
    217: new Tuple2<String, Map<String, List>>("Finnbarr", {
      "Chicken Poutine": ["M", 1, 7.00],
      "Water": ["N/A", 1, 1.00]
    })
  };*/

  @override
  _MyServerOrdersScreenState createState() => new _MyServerOrdersScreenState();
}

class _MyServerOrdersScreenState extends State<ServerOrdersScreen> {
  @override
  Widget build(BuildContext context) {

    Map<int, Tuple2<String, Map<String, List>>> customerOrders =
        new Map<int, Tuple2<String, Map<String, List>>>();

    Map<int, Tuple2<String, Map<String, List>>> customerPickup =
        new Map<int, Tuple2<String, Map<String, List>>>();

    return StreamBuilder(
        stream: Firestore.instance
            .collection('orders')
            .where("status", isEqualTo: 0)
            .where("server", isEqualTo: serverGlobals.user)
            .snapshots(),
        builder: (context, snapshot1) {
          if (!snapshot1.hasData) return const Text('Loading...');
          final int count = snapshot1.data.documents.length;
          for (int i = 0; i < count; i++) {
            //iterate each document(order)
            Map<String, List> allItems = new Map<String, List>();
            List orderQuery = snapshot1.data.documents[i]['items'];
            for (int j = 0; j < orderQuery.length; j++) {
              List ItemInfo = new List(3);
              if (orderQuery[j]["size"] != "-1") {
                ItemInfo[0] = orderQuery[j]["size"];
              } else {
                ItemInfo[0] = "";
              }
              ItemInfo[1] = orderQuery[j]["quantity"];
              ItemInfo[2] = orderQuery[j]["price"];

              allItems[orderQuery[j]["type"]] = ItemInfo;

              Tuple2<String, Map<String, List>> NameToOrder1 =
                  Tuple2<String, Map<String, List>>(
                      snapshot1.data.documents[i]["client"], allItems);

              customerOrders[snapshot1.data.documents[i]['orderNumber']] =
                  NameToOrder1;
            }
          }

          return StreamBuilder(
              stream: Firestore.instance
                  .collection('orders')
                  .where("status", isEqualTo: 1)
                  .where("server", isEqualTo: serverGlobals.user)
                  .snapshots(),
              builder: (context, snapshot2) {
                if (!snapshot2.hasData) return const Text('Loading...');
                final int count2 = snapshot2.data.documents.length;
                for (int i = 0; i < count2; i++) {
                  //iterate each document(order)
                  Map<String, List> allItems2 = new Map<String, List>();
                  List orderQuery = snapshot2.data.documents[i]['items'];
                  for (int j = 0; j < orderQuery.length; j++) {
                    List ItemInfo = new List(3);
                    if (orderQuery[j]["size"] != "-1") {
                      ItemInfo[0] = orderQuery[j]["size"];
                    } else {
                      ItemInfo[0] = "";
                    }
                    ItemInfo[1] = orderQuery[j]["quantity"];
                    ItemInfo[2] = orderQuery[j]["price"];

                    allItems2[orderQuery[j]["type"]] = ItemInfo;

                    Tuple2<String, Map<String, List>> NameToOrder2 =
                        Tuple2<String, Map<String, List>>(
                            snapshot2.data.documents[i]["client"], allItems2);

                    customerPickup[snapshot2.data.documents[i]['orderNumber']] =
                        NameToOrder2;
                    print(customerPickup);
                  }
                  // do some stuff with both streams here
                }
                return new PendingOrders(
                    customerOrders: customerOrders,
                    customerPickup: customerPickup,
                    taxPercent: ServerOrdersScreen.taxPercent,
                    snapshot1: snapshot1,
                    snapshot2: snapshot2);
              });
        });
  }
}
