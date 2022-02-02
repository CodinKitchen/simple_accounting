import 'package:flutter/material.dart';
import 'package:simple_accouting/pages/home.dart';
import 'package:simple_accouting/pages/operations.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: const Text('Mes opérations'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OperationsPage()),
              );
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance),
            title: const Text('Mes comptes'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
