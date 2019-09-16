import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasks_counter/models/models.dart';

class EmployeItem extends StatefulWidget {
  final Employe employe;
  Function(Employe, bool) callback;
  bool isChecked;
  EmployeItem(@required this.employe) {
    this.isChecked = employe.isChecked;
  }

  @override
  _EmployeItemState createState() => _EmployeItemState();
}

class _EmployeItemState extends State<EmployeItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
            widget.employe.name == null ? 'Nameless !!' : widget.employe.name,
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: CircleAvatar(
          radius: 26.0,
          child: ClipOval(
              child: widget.employe.image == null
                  ? Image.asset('assets/images/employee2.png')
                  : Image.memory(base64Decode(widget.employe.image))),
        ),
        trailing: Checkbox(
          onChanged: (bool value) {
            setState(() {
              widget.isChecked = !widget.isChecked;
              widget.callback(widget.employe, widget.isChecked);
            });
          },
          value: widget.isChecked,
        ),
      ),
    );
  }
}
