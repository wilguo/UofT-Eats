import 'package:flutter/material.dart';

class ClientFoodOrdered extends StatelessWidget {
  ClientFoodOrdered({Key key, this.order, this.subTotal})
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
            width: 180.0,
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
            width: 80.0,
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
            width: 60.0,
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
                        width: 130.0,
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
                        width: 130.0,
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
                        width: 130.0,
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