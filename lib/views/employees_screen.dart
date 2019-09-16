import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasks_counter/repositories/db_helper.dart';
import 'package:tasks_counter/views/views.dart';
import 'package:tasks_counter/models/models.dart';

class EmployeesScreen extends StatefulWidget {
  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  List<Employe> employees = [];
  List<Employe> selectedEmployees = [];
  var result;

  callback(Employe employee, bool isChecked) {
    if (isChecked) {
      addIfNotExits(selectedEmployees, employee);
    }
    if (!isChecked) {
      removeIfExits(selectedEmployees, employee);
    }
  }

  @override
  void initState() {
    getEmp();
    super.initState();
  }

  Future<List<Employe>> getEmp() async {
    employees = await DBHelper.getAllEmployees();
    setState(() {});
    for (Employe em in employees) {
      print(em);
    }
  }

  void addIfNotExits(List<Employe> employees, Employe employee) {
    bool notExits = true;
    for (Employe emp in employees) {
      if (emp.name == employee.name && emp.image == employee.image) {
        notExits = false;
      }
    }
    if (notExits) {
      employees.add(employee);
    }
  }

  void removeIfExits(List<Employe> employees, Employe employee) {
    employees.remove(employee);
  }

  @override
  Widget build(BuildContext context) {
    var result;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        title: Center(child: Text('Employees')),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 40.0,
              child: Center(
                child: Text(
                  'Choose employees to start',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: employees == null
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new EmployeItem(employees[index]);
                    },
                    padding: EdgeInsets.all(8.0),
                  ),
          ),
          Container(
            color: Color.fromARGB(255, 240, 240, 240),
            child: SizedBox(
              width: double.infinity,
              height: 74.0,
              child: Center(
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.green,
                  onPressed: () => {},
                  child: Text('Start !',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () async {
          result = await showDialog<Map<String, String>>(
            context: context,
            builder: (BuildContext context) => AddEmployeeDialog(),
            barrierDismissible: false,
          );
          if (result != null) {
            Employe employee =
                Employe(image: result['image'], name: result['name']);
            employees.add(employee);
            setState(() {
              print('setState !!');
            });
            print(result['name']);
            print(result['image']);
            for (int i = 0; i < employees.length; i++) {
              print(employees[i].name);
            }
            DBHelper.insertEmployee(employee);
          }
        },
      ),
    );
  }
}
