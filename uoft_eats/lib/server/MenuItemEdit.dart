import 'package:flutter/material.dart';
import 'package:uoft_eats/server/ServerDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uoft_eats/server/serverGlobals.dart' as serverGlobals;

void main() => runApp(new MenuItemEdit());

class MenuItemEdit extends StatefulWidget {
  MenuItemEdit({Key key, this.name, this.price}) : super(key: key);
  final String name;
  final Map<String, dynamic> price;

  @override
  _MenuItemEdit createState() => new _MenuItemEdit();
}

class _MenuItemEdit extends State<MenuItemEdit> {
  static final GlobalKey<FormState> _key = new GlobalKey<FormState>();

  final nameControllerFood = new TextEditingController();
  final nameControllerDrink = new TextEditingController();
  final priceControllerDrink = new TextEditingController();
  final priceController0 = new TextEditingController();
  final priceController1 = new TextEditingController();
  final priceController2 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new ServerDrawer(),
      appBar: AppBar(
      title: Text("Edit menu"),
      ),
      body: new StreamBuilder(
        stream: Firestore.instance.collection('servers/' + serverGlobals.user + '/menu').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          if (!snapshot.hasData) return new Text('Loading...');
          DocumentSnapshot foodItemDoc;
          for (final document in snapshot.data.documents) {
            if (document['name'] == widget.name) {
              foodItemDoc = document;
            }
          }
          return _buildForm(_key, foodItemDoc);
        },
      ),
    );
  }


  Widget _buildForm(GlobalKey<FormState> _key, DocumentSnapshot document) {
    List<String> sizes = widget.price.keys.toList();
    List<TextEditingController> availableController = [
      priceController0, priceController1, priceController2];
    List<TextEditingController> controllers = [];

    @override
    // ignore: unused_element
    void dispose() {
      nameControllerFood.dispose();
      super.dispose();
    }

    var children = <Widget> [];
    if (!document['foodOrDrink']) {
      children.add(new TextFormField(
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
      ),
      );
      children.add(
        new TextFormField(
          controller: priceControllerDrink,
          decoration: new InputDecoration(
            labelText: "Enter your new price",
          ),
          keyboardType: TextInputType.number,
          validator: (String value) {
            if (value.length == 0 || double.parse(value) <= 0) {
              return "Price invalid";
            }
            return null;
          },
        )
      );
    } else {
      children.add(new TextFormField(
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
      ),
      );
      for (final size in sizes) {
        children.add(
            new TextFormField(
              controller: availableController[availableController.length - 1],
              decoration: new InputDecoration(
                labelText: "Enter your new price for size $size",
              ),
              keyboardType: TextInputType.number,
              validator: (String value) {
                if (value.length == 0 || double.parse(value) <= 0) {
                  return "Price invalid";
                }
                return null;
              },
            )
        );
        TextEditingController popped = availableController.removeLast();
        controllers.add(popped);
      }
    }
    children.add(
      new RaisedButton(
        onPressed: () {
          if (_key.currentState.validate()) {
            if (document['foodOrDrink']) {
              Firestore.instance.runTransaction((transaction) async {
                DocumentSnapshot freshSnap =
                await transaction.get(document.reference);
                await transaction.update(freshSnap.reference, {
                  'name': nameControllerFood.text,
                  'pricing.small': double.parse(priceController0.text),
                  'pricing.medium': double.parse(priceController1.text),
                  'pricing.large': double.parse(priceController2.text),
                });
              });
            } else {
              Firestore.instance.runTransaction((transaction) async {
                DocumentSnapshot freshSnap =
                await transaction.get(document.reference);
                await transaction.update(freshSnap.reference, {
                  'name': nameControllerDrink.text,
                  'pricing.all': double.parse(priceControllerDrink.text),
                });
              });
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

}

