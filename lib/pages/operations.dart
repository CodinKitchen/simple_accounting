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

class OperationsPage extends StatefulWidget {
  const OperationsPage({Key? key}) : super(key: key);

  @override
  _OperationsPageState createState() => _OperationsPageState();
}

class _OperationsPageState extends State<OperationsPage> {
  late Future<List<Operation>> _operationWidgets;

  @override
  void initState() {
    super.initState();
    _operationWidgets = _loadOperations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the SimpleAccounting object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Simple accounting - Opérations'),
      ),
      drawer: const Menu(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: FutureBuilder(
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
          ),
        ),
      ),
    );
  }
}
