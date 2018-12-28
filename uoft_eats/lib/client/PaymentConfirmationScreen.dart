import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uoft_eats/client/clientGlobals.dart' as clientGlobals;
import 'package:uoft_eats/client/clientReceipt.dart';

class PaymentConfirmationScreen extends StatelessWidget{
  PaymentConfirmationScreen({Key key, this.subtotal, this.order, this.truck})
    : super(key: key);

  final String truck;
  final Map order;
  final double subtotal;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Payment Confirmation"),
        backgroundColor: Colors.blue,
      ),
      body: new PaymentConfirmation(order: order, subTotal: subtotal, truck: truck));
  }
}

class PaymentConfirmation extends StatelessWidget {
  PaymentConfirmation({Key key, this.order, this.subTotal, this.truck})
      : super(key: key);

  final String truck;
  final Map order;
  final double subTotal;

  List<List> myOrder;


  List<List> createOrder(Map myOrder){

    List<List> temp = [];
    var keys = myOrder.keys.toList();
    for(int i = 0; i < myOrder.length; i++){
      temp.add(myOrder[keys[i]]);
    }

    return temp;
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: new ListView(
          children: [
            //Header
            new PaymentConfirmationHeader(order: createOrder(order), subTotal: subTotal, truck: truck),
            new ReceiptHeaders(),
            new Divider(color: Colors.blue),
            new OrderSummary(order: createOrder(order), subTotal: subTotal,),
            //Content
          ],
        )));
  }
}

class PaymentConfirmationHeader extends StatelessWidget {
  List order;
  double subTotal;

  PaymentConfirmationHeader({Key key, this.order, this.subTotal, this.truck})
    : super(key: key);

  final String truck;
  var headerHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Color.fromRGBO(220, 220, 220, 100.0),
      height: headerHeight,
      padding: EdgeInsets.only(top: 20.0),
      child: new Column(
        children: <Widget>[
          new Text("ORDER TOTAL",
            style:
            new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
          new Container(
            height: 5.0,
          ),
          new Text(
            "\$" + (subTotal * 1.13).toStringAsFixed(2),
            style: moneyTextStyle(),
          ),
          new Container(
            height: 10.0,
          ),
          new ConfirmButton(order: order, truck: truck, subtotal: subTotal,),
          new Container(
            padding: EdgeInsets.only(left: 10.0),
            height: 30.0,
//            color: Colors.green,
            alignment: Alignment.bottomLeft,
          )
        ],
      ));
  }
}

class OrderSummary extends StatelessWidget {
  OrderSummary({Key key, this.order, this.subTotal})
    : super(key: key);

  List order;
  final double listSpacing = 12.0;
  double subTotal;

  List<Widget> _getItems() {
    List<String> listOfItems = [];
    for(var i = 0; i < order.length; i++){
      listOfItems.add(order[i][1].toString());
    }

    List<Widget> orderWidgets = new List<Widget>();
    for (var i = 0; i < listOfItems.length; i++) {
      if(order[i][0] > 0){
        orderWidgets.add(new Container(
          width: 160.0,
          padding: new EdgeInsets.only(bottom: listSpacing, left: 20.0),
          child: new Text(listOfItems[i])));
      }
    }
    return orderWidgets;
  }

  List<Widget> _getSizes() {
    List<String> listOfSizes = [];
    for(var i = 0; i < order.length; i++){
      listOfSizes.add(order[i][2].toString());
    }

    List<Widget> orderWidgets = new List<Widget>();
    for (var i = 0; i < listOfSizes.length; i++) {
      if(order[i][0] > 0){
        orderWidgets.add(new Container(
          width: 70.0,
          padding: new EdgeInsets.only(bottom: listSpacing),
          child: new Text(listOfSizes[i])));
      }
    }
    return orderWidgets;
  }

  List<Widget> _getQuantities() {
    List<String> listOfQuantities = [];
    for(var i = 0; i < order.length; i++){
      listOfQuantities.add(order[i][0].toString());
    }

    List<Widget> orderWidgets = new List<Widget>();
    for (var i = 0; i < listOfQuantities.length; i++) {
      if(order[i][0] > 0){
        orderWidgets.add(new Container(
          width: 70.0,
          padding: new EdgeInsets.only(bottom: listSpacing, left: 10.0),
          child: new Text(listOfQuantities[i])));
      }
    }
    return orderWidgets;
  }

  List<Widget> _getPrices() {
    List<String> listOfPrices = [];
    for(var i = 0; i < order.length; i++){
      listOfPrices.add('\$${(order[i][3] * order[i][0]).toStringAsFixed(2)}');
    }

    List<Widget> orderWidgets = new List<Widget>();
    for (var i = 0; i < listOfPrices.length; i++) {
      if(order[i][0] > 0){
        orderWidgets.add(new Container(
          width: 60.0,
          padding: new EdgeInsets.only(bottom: listSpacing),
          child: new Text(listOfPrices[i])));
      }
    }
    return orderWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _getItems()),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _getSizes()),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _getQuantities()),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _getPrices()),
            ],
          ),
          new Divider(color: Colors.grey),
          new Container(
            height: 20.0,
            child: new Row(
              children: <Widget>[
                new Container(
                  width: 110.0,
                  padding: new EdgeInsets.only(bottom: listSpacing, left: 20.0),
                  margin: new EdgeInsets.only(right: 190.0),
                  child: new Text(
                    "Subtotal",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
                    )
                  )
                ),
                new Container(
                  padding: new EdgeInsets.only(bottom: listSpacing),
                  child: new Text(""
                    "\$" + subTotal.toStringAsFixed(2),
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
                    )
                  )
                )
              ],
            )
          ),
          new Container(height: listSpacing,),
          new Container(
            height: 20.0,
            child: new Row(
              children: <Widget>[
                new Container(
                  width: 110.0,
                  padding: new EdgeInsets.only(bottom: listSpacing, left: 20.0),
                  margin: new EdgeInsets.only(right: 190.0),
                  child: new Text(
                    "Taxes",
                    style: new TextStyle(
                      fontSize: 15.0
                    )
                  )
                ),
                new Container(
                  padding: new EdgeInsets.only(bottom: listSpacing),
                  child: new Text("\$" + (subTotal * 0.13).toStringAsFixed(2))
                )
              ],
            )
          ),
          new Divider(color: Colors.grey),
          new Container(
            height: 20.0,
            child: new Row(
              children: <Widget>[
                new Container(
                  width: 110.0,
                  padding: new EdgeInsets.only(bottom: listSpacing, left: 20.0),
                  margin: new EdgeInsets.only(right: 190.0),
                  child: new Text(
                    "Total",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
                    )
                  )
                ),
                new Container(
                  padding: new EdgeInsets.only(bottom: listSpacing),
                  child: new Text(
                    "\$" + (subTotal * 1.13).toStringAsFixed(2),
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
                    )
                  )
                )
              ],
            )
          ),

        ],
      ));
  }
}

class ReceiptHeaders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new Container(
      padding: new EdgeInsets.only(top: 20.0),
      child: new Row(
        children: <Widget>[
          new Container(
            width: 160.0,
            child: new Text("Item", style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,)),
            padding: new EdgeInsets.only(left: 20.0)),
          new Container(
            width: 70.0,
            child: new Text("Size", style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,)),
//            padding: new EdgeInsets.only(right: 50.0)
          ),
          new Container(
            width: 70.0,
            child: new Text("QTY", style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,)),
//            padding: new EdgeInsets.only(right: 38.0)
          ),
          new Container(
            width: 60.0,
            child: new Text("Price", style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,)))
        ],
      ));
  }
}

class ConfirmButton extends StatelessWidget {
  final List order;

  ConfirmButton({Key key, this.order, this.truck, this.subtotal})
    : super(key: key);

  final String truck;
  final double subtotal;

  @override
  Widget build(BuildContext context) {
    var button = Container(
        child: RaisedButton(
            child: Text("Place Order"),
            elevation: 5.0,
            color: Colors.green,
            onPressed: (){confirmOrder(context, order, truck, subtotal);},
            ));
    return button;
  }

// TODO: implement this alert + redirect to receipt page if wanted
void confirmOrder(BuildContext context, List orders, String truck, double subtotal) async {
    Firestore fs = Firestore.instance;
    String user = clientGlobals.user;

    List items = [];
    for (int i = 0; i < orders.length; i++) {
        if (orders[i][0] != 0) {
          Map map = {};
          map['type'] = orders[i][1];
          map['size'] = orders[i][2];
          map['quantity'] = orders[i][0];
          map['price'] = orders[i][3];
          items.add(map);
        }
    }

    QuerySnapshot query = await fs.collection('orders').getDocuments();
    List<DocumentSnapshot> docs = query.documents;

    int orderNum = 0;
    for (int i = 0; i < docs.length; i++) {
        if (docs[i]['orderNumber'] > orderNum) {
            orderNum = docs[i]['orderNumber'];
        }
    }

    String server = truck;

    fs.collection('orders').document()
        .setData({"client": user, "items": items, "orderNumber": orderNum + 1, "server": server, "status": 0});

    var alert = AlertDialog(
        title: Text("Order has been placed!"),
        content: Text("Order Number: 10234")
    );
    showDialog(
        context: context,
        builder: (BuildContext context){
          return alert;
        }
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ClientReceipt(
                orderNum: orderNum + 1,
                foodTruck: server,
                order: orders,
                subtotal: subtotal,
            )));
  }
}

TextStyle defaultTextStyle() {
  return TextStyle(fontSize: 20.0, decoration: TextDecoration.none);
}

TextStyle moneyTextStyle() {
  return TextStyle(
      fontSize: 50.0,
      color: Color.fromRGBO(0, 100, 0, 100.0),
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);
}
