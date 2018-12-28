import 'package:flutter/material.dart';
import 'package:uoft_eats/server/ServerDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uoft_eats/server/serverGlobals.dart' as serverGlobals;

void main() => runApp(new MenuAddItem());

class MenuAddItem extends StatefulWidget {
  MenuAddItem({Key key, this.isFood}) : super(key: key);

  final bool isFood;

  @override
  _MenuAddItem createState() => new _MenuAddItem();
}

class _MenuAddItem extends State<MenuAddItem> {
  static final GlobalKey<FormState> _key = new GlobalKey<FormState>();

  final nameControllerFood = new TextEditingController();
  final nameControllerDrink = new TextEditingController();
  final priceControllerDrink = new TextEditingController();
  final priceController0 = new TextEditingController();
  final priceController1 = new TextEditingController();
  final priceController2 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    String type;
    if (widget.isFood) {
      type = 'Food';
    } else {
      type = 'Drink';
    }
    return new Scaffold(
      drawer: new ServerDrawer(),
      appBar: AppBar(
        title: Text("Add $type"),
      ),
      body: new StreamBuilder(
        stream: Firestore.instance.collection('servers/' + serverGlobals.user + '/menu').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          if (!snapshot.hasData) return new Text('Loading...');
          return _buildForm(
              Firestore.instance.collection('servers/' + serverGlobals.user + '/menu')
          );
        },
      ),
    );
  }

  Widget _buildForm(CollectionReference collection) {
    var children = <Widget> [];
    if (widget.isFood) {
      children.add(
        new TextFormField(
          controller: nameControllerFood,
          decoration: new InputDecoration(
            labelText: "Enter your new name",
          ),
          keyboardType: TextInputType.text,
          validator: (String value) {
            if (value.length == 0) {
              return "Name cannot be empty";
            }
            return null;
          },
        )
      );
      children.add(_buildPrices('small', priceController0));
      children.add(_buildPrices('medium', priceController1));
      children.add(_buildPrices('large', priceController2));
    } else {
      children.add(
        new TextFormField(
          controller: nameControllerDrink,
          decoration: new InputDecoration(
            labelText: "Enter your new name",
          ),
          keyboardType: TextInputType.text,
          validator: (String value) {
            if (value.length == 0) {
              return "Name cannot be empty";
            }
            return null;
          },
        )
      );
      children.add(_buildPrices('', priceControllerDrink));
    }
    children.add(
      new RaisedButton(
        onPressed: () {
          if (_key.currentState.validate()) {
            if (widget.isFood) {
              collection.document(nameControllerFood.text.toLowerCase().replaceAll(RegExp(r" "), "_")).setData(
                {
                  'name': nameControllerFood.text,
                  'pricing': {
                    'small': double.parse(priceController0.text),
                    'medium': double.parse(priceController1.text),
                    'large': double.parse(priceController2.text),
                  },
                  'foodOrDrink' : true
                }
              );

            } else {
              collection.document(nameControllerDrink.text.toLowerCase().replaceAll(RegExp(r" "), "_")).setData(
                {
                  'name': nameControllerDrink.text,
                  'pricing': {
                    'all': double.parse(priceControllerDrink.text),
                  },
                  'foodOrDrink' : false
                }
              );
            }
            Navigator.of(context).pop();
          }
        },
        child: Text("Confirm")
      )
    );
    return new Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: ListView(
            children: children,
          ),
        )
    );
  }

  Widget _buildPrices(String size, TextEditingController controller) {
    String label = "Enter your new price";
    if (size != '') {
      label = 'Enter your new price for size $size';
    }
    return new TextFormField(
      controller: controller,
      decoration: new InputDecoration(
        labelText: label,
      ),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.length == 0 || double.parse(value) <= 0) {
          return "Price invalid";
        }
        return null;
      },
    );
  }
}