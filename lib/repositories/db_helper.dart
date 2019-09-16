import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tasks_counter/models/models.dart';

class DBHelper {
  static Database _db;

  // get the database refrence
  static Future<Database> getDatabaseRefrence() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'employee_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE IF NOT EXISTS employees(name TEXT PRIMARY KEY, image TEXT)",
        );
      },
      version: 1,
    );
    return database;
  }

  // sigleton design patter to instanciate the database once and only
  static Future<Database> getDB() async {
    if (_db == null) {
      _db = await getDatabaseRefrence();
      return _db;
    } else
      return _db;
  }

  // function to insert employees to database
  static Future<void> insertEmployee(Employe employee) async {
    // Get a reference to the database.
    final Database db = await getDB();
    await db.insert(
      'employees',
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the Employees from the employees table.
  static Future<List<Employe>> getAllEmployees() async {
    // Get a reference to the database.
    final Database db = await getDB();
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('employees');

    // Convert the List<Map<String, dynamic> into a List<Employee>.
    return List.generate(maps.length, (i) {
      return Employe(
        name: maps[i]['name'],
        image: maps[i]['image'],
      );
    });
  }

  // update employee
  static Future<void> updateEmployee(Employe employee) async {
    // Get a reference to the database.
    final db = await getDB();

    // Update the given Employee.
    await db.update(
      'employees',
      employee.toMap(),
      // Ensure that the Employee has a matching name.
      where: "name = ?",
      // Pass the Employees's name as a whereArg to prevent SQL injection.
      whereArgs: [employee.name],
    );
  }

// delete employee
  static Future<void> deleteEmployee(String name) async {
    // Get a reference to the database.
    final db = await getDB();

    // Remove the Employee from the Database.
    await db.delete(
      'employees',
      // Use a `where` clause to delete a specific employee.
      where: "name = ?",
      // Pass the Employee's id as a whereArg to prevent SQL injection.
      whereArgs: [name],
    );
  }
}
