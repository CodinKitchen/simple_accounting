import 'package:flutter/material.dart';
import 'package:simple_accouting/pages/accounts/accounts_list.dart';
import 'package:simple_accouting/pages/accounts/categories_list.dart';
import '../../menu.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the SimpleAccounting object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Simple accounting - Your accounts'),
      ),
      drawer: const Menu(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: IndexedStack(
            children: const <Widget>[
              AccountsListPage(),
              AccountsCategoriesPage(),
            ],
            index: _selectedIndex,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Comptes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.source),
            label: 'Catégories de comptes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
