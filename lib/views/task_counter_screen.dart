import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks_counter/views/views.dart';

class TaskCounterScreen extends StatefulWidget {
  @override
  _TaskCounterScreenState createState() => _TaskCounterScreenState();
}

class _TaskCounterScreenState extends State<TaskCounterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB( 255, 240, 240, 240),
      appBar: AppBar(
        title: Center(
          child: Text('Tasks Counter'),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          TaskCounterItem(),
          TaskCounterItem(),
        ],
      ),
    );
  }
}
