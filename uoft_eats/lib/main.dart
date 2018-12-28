import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'LoginScreen.dart';
import 'NewAccountScreen.dart';
import 'SupportScreen.dart';

import 'client/MenusScreen.dart';
import 'client/OrdersScreen.dart';
import 'client/PaymentScreen.dart';
import 'client/SettingsScreen.dart';
import 'client/TemplateMenuScreen.dart';
import 'client/PaymentConfirmationScreen.dart';

import 'server/ServerHomeScreen.dart';
import 'server/ServerOrdersScreen.dart';
import 'server/BillingInfoScreen.dart';
import 'server/QuantitiesOrderedScreen.dart';
import 'server/ServerOrderHistory.dart';
import 'server/MenuEditItemList.dart';
import 'server/HoursOfOperationScreen.dart';


void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {


  @override
  void initState(){

    Firestore.instance.collection('mountains').document()
      .setData({ 'title': 'Mount Anna', 'type': 'Amazing Wilbert' });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'UofT Eats',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginScreen(title: 'Login'),

      // TODO: Add to tree structure for navigating screens as needed
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(title: 'Login'),
        '/newAccount': (BuildContext context) => NewAccountScreen(title: 'New Account'),
        '/support': (BuildContext context) => SupportScreen(title: 'Support'),

        '/client/menus': (BuildContext context) => MenusScreen(title: 'Menus'),
        '/client/orders': (BuildContext context) => OrdersScreen(title: 'Orders'),
        '/client/payment': (BuildContext context) => PaymentScreen(title: 'Payment'),
        '/client/settings': (BuildContext context) => SettingsScreen(title: 'Settings'),
        '/client/menus/template': (BuildContext context) => TemplateMenuScreen(title: 'Template Menu'),
        '/client/paymentConfirmation': (BuildContext context) => PaymentConfirmationScreen(),

        '/server': (BuildContext context) => ServerHomeScreen(title: 'Home'),
        '/server/menus': (BuildContext context) => MenuEditItemList(title: 'Edit Menu Items',),
        '/server/orders': (BuildContext context) => ServerOrdersScreen(title: 'Orders'),
        '/server/billingInfo': (BuildContext context) => BillingInfoScreen(title: 'Billing Info'),
        '/server/quantities': (BuildContext context) => QuantitiesOrderedScreen(title: 'Quantities'),
        '/server/orderhistory': (BuildContext context) => ServerOrderHistory(title: 'Order History'),
        '/server/editHoursOfOperation': (BuildContext context) => HoursOfOperationScreen(),
      },
    );
  }
}