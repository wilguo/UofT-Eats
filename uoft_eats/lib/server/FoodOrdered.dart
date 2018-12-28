import 'package:flutter/material.dart';

class FoodOrdered extends StatefulWidget {
  final Map<String, List> order;
  final double taxPercent;

  FoodOrdered({Key key, this.order, this.taxPercent}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _FoodOrdered();
  }
}

class _FoodOrdered extends State<FoodOrdered> {
  final double listSpacing = 12.0;

  List<Widget> _getItems(Map<String, List> order) {
    List<String> listOfItems = (order.keys).toList();
    List<Widget> orderWidgets = new List<Widget>();
    for (var i = 0; i < listOfItems.length; i++) {
      orderWidgets.add(new Container(
          width: 115.0,
          padding: new EdgeInsets.only(bottom: listSpacing),
          child: new Text(listOfItems[i])));
    }
    return orderWidgets;
  }

  List<Widget> _getSizes(Map<String, List> order) {
    List<String> listOfItems = (order.keys).toList();
    List<Widget> sizeWidgets = new List<Widget>();
    for (String item in listOfItems) {
      sizeWidgets.add(new Container(
          width: 95.0,
          padding: new EdgeInsets.only(bottom: listSpacing),
          child: new Text(order[item][0])));
    }
    return sizeWidgets;
  }

  List<Widget> _getQuantities(Map<String, List> order) {
    List<String> listOfItems = (order.keys).toList();
    List<Widget> quantityWidgets = new List<Widget>();
    for (String item in listOfItems) {
      String num = (order[item][1]).toString();
      quantityWidgets.add(new Container(
          width: 82.0,
          padding: new EdgeInsets.only(bottom: listSpacing),
          child: new Text(num + "x")));
    }
    return quantityWidgets;
  }

  List<Widget> _getPrices(Map<String, List> order) {
    List<String> listOfItems = (order.keys).toList();
    List<Widget> priceWidgets = new List<Widget>();
    for (String item in listOfItems) {
      priceWidgets.add(new Container(
          padding: new EdgeInsets.only(bottom: listSpacing),
          child: new Text("\$" + (order[item][2].toStringAsFixed(2)))));
    }
    return priceWidgets;
  }

  Widget _getTotals() {
    List<String> listOfItems = (widget.order.keys).toList();
    double subtotal = 0.00;
    for (String item in listOfItems) {
      List itemInfo = widget.order[item];
      int num = itemInfo[1];
      subtotal += (num * double.parse(itemInfo[2].toString()));
    }
    double tax = subtotal * widget.taxPercent;
    double total = (subtotal + tax);

    return new Column(children: <Widget>[
      new Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        new Container(
            padding: new EdgeInsets.only(top: 10.0, bottom: listSpacing),
            child: new Text("Subtotal: \$" + subtotal.toStringAsFixed(2))),
        new Container(
            padding: new EdgeInsets.only(bottom: listSpacing),
            child: new Text("Tax: \$" + tax.toStringAsFixed(2))),
        new Divider(color: Colors.grey),
        new Container(
          padding: new EdgeInsets.only(top: 10.0),
          child: new Text(
            "Total: \$" + total.toStringAsFixed(2),
            textAlign: TextAlign.end,
          ),
        )
      ])
    ]);
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
                    children: _getItems(widget.order)),
                new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _getSizes(widget.order)),
                new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _getQuantities(widget.order)),
                new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _getPrices(widget.order)),
              ],
            ),
            new Divider(color: Colors.grey),
            _getTotals(),
          ],
        ));
  }
}