import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks_counter/models/models.dart';

class TaskCounterItem extends StatefulWidget {
  final Employe employee;
  TaskCounterItem({@required this.employee}) : assert(employee != null);
  @override
  _TaskCounterItemState createState() => _TaskCounterItemState();
}

class _TaskCounterItemState extends State<TaskCounterItem> {
  int count = 0;
  String prefix = '0';
  String name;
  String image;
  @override
  void initState() {
    name = widget.employee.name;
    image = widget.employee.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          )
        ],
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Center(
              child: Text(
                name == null ? 'Nameless !!' : name,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            leading: CircleAvatar(
              radius: 26.0,
              child: ClipOval(
                  child: image == null
                      ? Image.asset('assets/images/employee2.png')
                      : Image.memory(base64Decode(image))),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                '$prefix$count',
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // minus button
              FloatingActionButton(
                heroTag: '${name}1',
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.remove),
                onPressed: () {
                  if (count > 0) {
                    if (count <= 10) {
                      prefix = '0';
                    }
                    setState(() {
                      count--;
                    });
                  }
                },
              ),
              // plus button
              FloatingActionButton(
                heroTag: '${name}2',
                backgroundColor: Colors.greenAccent,
                child: Icon(Icons.add),
                onPressed: () {
                  if (count < 99) {
                    setState(() {
                      if (count >= 9) {
                        prefix = '';
                      }
                      count++;
                    });
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
