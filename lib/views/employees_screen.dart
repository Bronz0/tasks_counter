import 'package:flutter/material.dart';
import 'package:tasks_counter/repositories/db_helper.dart';
import 'package:tasks_counter/views/views.dart';
import 'package:tasks_counter/models/models.dart';

class EmployeesScreen extends StatefulWidget {
  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  _EmployeesScreenState();
  List<Employe> employees = [];
  List<Employe> selectedEmployees = new List<Employe>();
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
            content: Text('Do You Really Want To Quit ?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Cancel'),
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
    var result;
    selectedEmployees = [];
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
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
                        content: Text(
                            'Do You Really Want To Delete All Employees ?'),
                        actions: <Widget>[
                          new FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: new Text('Cancel'),
                          ),
                          new FlatButton(
                            onPressed: () {
                              DBHelper.deleteAll('employees');
                              employees = [];
                              selectedEmployees = [];
                              setState(() {});
                              Navigator.of(context).pop(false);
                            },
                            child: new Text('Yes'),
                          ),
                        ],
                      ),
                    ) ??
                    false;
              },
            ),
          ],
          title: Center(child: Text('Employees')),
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              child: SizedBox(
                width: double.infinity,
                height: 40.0,
                child: Center(
                  child: Text(
                    'Choose Employees to Start Counting',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: employees == []
                  ? Container(
                      color: Colors.red,
                    )
                  : ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          key: Key(employees[index].name),
                          background: Container(color: Colors.redAccent),
                          onDismissed: (direction) {
                            int _index = index;
                            String _name = employees[index].name;
                            // Remove the item from the database
                            DBHelper.deleteEmployee(_name);
                            // Remove the item from the data source.
                            setState(() {
                              employees.removeAt(_index);
                            });

                            // Then show a snackbar.
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "${_name} dismissed, the index = $_index",
                                    ),
                                    FlatButton(
                                      child: Icon(Icons.undo),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          child: new EmployeItem(employees[index], callback),
                        );
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
                    color: Colors.greenAccent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TaskCounterScreen(employees: selectedEmployees),
                        ),
                      );
                    },
                    child: Text('Start',
                        style: TextStyle(
                          fontSize: 42.0,
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
              setState(() {});
              DBHelper.insertEmployee(employee);
            }
          },
        ),
      ),
    );
  }
}
