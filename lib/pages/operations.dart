import 'package:flutter/material.dart';
import '../menuDrawer.dart';

class OperationsPage extends StatefulWidget {
  const OperationsPage({Key? key}) : super(key: key);

  @override
  _OperationsPageState createState() => _OperationsPageState();
}

class _OperationsPageState extends State<OperationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the SimpleAccounting object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Simple Accounting'),
      ),
      drawer: MenuDrawer(),
      body: Center(
        child: Text('Operations'),
      ),
    );
  }
}
