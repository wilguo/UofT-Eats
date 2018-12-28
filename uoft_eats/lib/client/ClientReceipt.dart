import 'package:flutter/material.dart';
import 'package:uoft_eats/client/MainDrawer.dart';
import 'ClientReceiptHeaders.dart';
import 'ClientFoodOrdered.dart';


class ClientReceipt extends StatelessWidget {
  final int orderNum;
  final String foodTruck;
  //final Map<String, List> order;
  final List order;
  final double subtotal;

  ClientReceipt({Key key, this.orderNum, this.foodTruck, this.order, this.subtotal})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Receipt #$orderNum"),
        ),
        drawer: MainDrawer(),
        body: Container(
            padding: new EdgeInsets.only(top: 20.0),
            child: new ListView(
              children: <Widget>[
                new Align(
                    alignment: Alignment.topRight,
                    child: new Text("Order#$orderNum        ",
                        style: new TextStyle(fontSize: 16.0))),
                new Align(
                  alignment: Alignment.topLeft,
                  child: new Text("    $foodTruck",
                      style: new TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
                ClientReceiptHeaders(),
                new Divider(color: Colors.blue),
                ClientFoodOrdered(order: order, subTotal: subtotal,),
              ],
            )));
  }
}

