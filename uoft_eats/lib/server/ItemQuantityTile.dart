import 'package:flutter/material.dart';

class ItemQuantityTile extends StatefulWidget {
    final String title;
    int quantity;
    final bool foodOrDrink;
    final String size;

    ItemQuantityTile(this.title, this.quantity, this.size, this.foodOrDrink);

    @override
    _ItemQuantityTileState createState() => new _ItemQuantityTileState();

    void increaseQuantity(int addedQuantity) {
        this.quantity += addedQuantity;
    }

    String getTitle() {
        return this.title;
    }

    int getQuantity() {
        return this.quantity;
    }

    bool getFoodOrDrink() {
        return this.foodOrDrink;
    }

    String getSize() {
        return this.size;
    }
}

class _ItemQuantityTileState extends State<ItemQuantityTile> {
    @override
    Widget build(BuildContext context) {
        return new ListTile(
            leading: Icon(
                widget.foodOrDrink ? Icons.fastfood : Icons.fastfood,
            ),
            title: new Text(widget.size + " " + widget.title),
            trailing: new Text(widget.quantity.toString()),
        );
    }
}