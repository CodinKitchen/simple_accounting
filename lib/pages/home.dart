import 'package:flutter/material.dart';
import '../menuDrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        child: Text('Home'),
      ),
    );
  }
}
