import 'package:flutter/material.dart';
import 'package:uoft_eats/client/clientGlobals.dart' as clientGlobals;

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Icon(Icons.fastfood),
          decoration: BoxDecoration(
            color: Colors.red,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.add_shopping_cart),
          title: Text('Menus'),
          onTap: () {
            Navigator.pop(context); // Closes the drawer before moving
            Navigator.pushReplacementNamed(context, '/client/menus');
          },
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: Text('Orders'),
          onTap: () {
            Navigator.pop(context); // Closes the drawer before moving
            Navigator.pushReplacementNamed(context, '/client/orders');
          },
        ),
        ListTile(
          leading: const Icon(Icons.attach_money),
          title: Text('Payment'),
          onTap: () {
            Navigator.pop(context); // Closes the drawer before moving
            Navigator.pushReplacementNamed(context, '/client/payment');
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            clientGlobals.user = "";
            Navigator.pop(context); // Closes the drawer before moving
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    ));
  }
}

// TODO use for implementing cleaner fading page transitions
/*class FadeRoute extends PageRouteBuilder {
  final Widget widget;

  FadeRoute({this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: child,
          );
        });
}*/
