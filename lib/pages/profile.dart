import 'package:flutter/material.dart';
import 'package:simple_accouting/database/db_helper.dart';
import 'package:simple_accouting/database/models/operation.dart';
import '../menu.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _operationWidgets = <Widget>[];

  void _loadOperations() async {
    final database = await DBHelper.database();
    final result = await database.query('operations');
    List<Operation> _operations = result.isNotEmpty
        ? result.map((item) => Operation.fromDatabase(item)).toList()
        : [];

    List<Widget> operationWidgets = _operations
        .map((Operation operation) =>
            ListTile(title: Text(operation.amount.toString())))
        .toList();

    setState(() {
      _operationWidgets = operationWidgets;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadOperations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the SimpleAccounting object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Simple accounting - Profil'),
      ),
      drawer: const Menu(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ListView(
            children: _operationWidgets,
          ),
        ),
      ),
    );
  }
}
