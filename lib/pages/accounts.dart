import 'package:flutter/material.dart';
import 'package:simple_accouting/database/db_helper.dart';
import 'package:simple_accouting/database/models/operation.dart';
import '../menu.dart';

Future<List<Operation>> _loadOperations() async {
  final database = await DBHelper.database();
  final result = await database.query('operations');
  return result.isNotEmpty
      ? result.map((item) => Operation.fromDatabase(item)).toList()
      : [];
}

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    AccountsListPage(),
    AccountsCategoriesPage(),
  ];

  static final List<Widget> _actions = <Widget>[
    FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add),
    ),
    FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add),
    ),
  ];

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
              children: _pages,
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
        floatingActionButton: IndexedStack(
          children: _actions,
          index: _selectedIndex,
        ));
  }
}

class AccountsListPage extends StatefulWidget {
  const AccountsListPage({Key? key}) : super(key: key);

  @override
  _AccountsListPageState createState() => _AccountsListPageState();
}

class _AccountsListPageState extends State<AccountsListPage> {
  late Future<List<Operation>> _operationWidgets;

  @override
  void initState() {
    super.initState();
    _operationWidgets = _loadOperations();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _operationWidgets,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Operation> operations = snapshot.data;
          return ListView.builder(
              itemCount: operations.length,
              itemBuilder: (context, index) {
                Operation operation = operations[index];
                return Text(operation.amount.toString());
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class AccountsCategoriesPage extends StatefulWidget {
  const AccountsCategoriesPage({Key? key}) : super(key: key);

  @override
  _AccountsCategoriesPageState createState() => _AccountsCategoriesPageState();
}

class _AccountsCategoriesPageState extends State<AccountsCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return const Text('data');
  }
}
