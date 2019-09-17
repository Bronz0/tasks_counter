import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasks_counter/views/views.dart';
import 'package:tasks_counter/models/models.dart';

class TaskCounterScreen extends StatefulWidget {
  final List<Employe> employees;
  TaskCounterScreen({@required this.employees});
  @override
  _TaskCounterScreenState createState() => _TaskCounterScreenState();
}

class _TaskCounterScreenState extends State<TaskCounterScreen> {
  @override
  void initState() {
    for (Employe emp in widget.employees) {
      print(emp);
    }
    super.initState();
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Center(
              child: new Text(
                'Are you Sure ?',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: new Text('You will lose all the progress !'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // to hide the bottom navigation bar and top status bar
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        appBar: AppBar(
          title: Center(
            child: Text('Tasks Counter'),
          ),
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: widget.employees.length,
          itemBuilder: (BuildContext context, int index) {
            return TaskCounterItem(employee: widget.employees[index]);
          },
        ),
      ),
    );
  }
}
