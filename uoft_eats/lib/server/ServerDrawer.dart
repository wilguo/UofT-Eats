import 'package:flutter/material.dart';
import 'package:uoft_eats/server/serverGlobals.dart' as serverGlobals;

class ServerDrawer extends StatelessWidget {
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
                      leading: const Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () {
                        Navigator.pop(context); // Closes the drawer before moving
                        Navigator.pushReplacementNamed(context, '/server');
                      },
                    ),
                    ListTile(
                        leading: const Icon(Icons.add_shopping_cart),
                        title: Text('Menus'),
                        onTap: () {
                            Navigator.pop(context); // Closes the drawer before moving
                            Navigator.pushReplacementNamed(context, '/server/menus');
                        },
                    ),
                    ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text('Pending Orders'),
                        onTap: () {
                            Navigator.pop(context); // Closes the drawer before moving
                            Navigator.pushReplacementNamed(context, '/server/orders');
                        },
                    ),
                    ListTile(
                        leading: const Icon(Icons.format_list_numbered),
                        title: Text('Quantities'),
                        onTap: () {
                            Navigator.pop(context); // Closes the drawer before moving
                            Navigator.pushReplacementNamed(context, '/server/quantities');
                        },
                    ),
                    ListTile(
                        leading: const Icon(Icons.history),
                        title: Text('Order History'),
                        onTap: () {
                            Navigator.pop(context); // Closes the drawer before moving
                            Navigator.pushReplacementNamed(context, '/server/orderhistory');
                        },
                    ),
                    ListTile(
                        leading: const Icon(Icons.attach_money),
                        title: Text('Billing Info'),
                        onTap: () {
                            Navigator.pop(context); // Closes the drawer before moving
                            Navigator.pushReplacementNamed(context, '/server/billingInfo');
                        },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text('Edit Hours of Operation'),
                      onTap: () {
                        Navigator.pop(context); // Closes the drawer before moving
                        Navigator.pushReplacementNamed(context, '/server/editHoursOfOperation');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: Text('Logout'),
                      onTap: () {
                          serverGlobals.user = "";
                          Navigator.pop(context); // Closes the drawer before moving
                          Navigator.pushReplacementNamed(context, '/login');
                      },
                    )
                ],
            ));
    }
}