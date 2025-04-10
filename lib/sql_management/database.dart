import 'package:sqflite/sqflite.dart';
import 'package:flutter_sqlite/sql_management/model_students.dart';
import 'package:flutter_sqlite/sql_management/model_students_fields.dart';

class DataBase {
  Future<Database> initializedDB() async {
    String databasePath = await getDatabasesPath();
    final path = '$databasePath/students.db';

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  // create databases
  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE ${StudentFields.tableName} (
          ${StudentFields.id} ${StudentFields.typeId},
          ${StudentFields.firstName} ${StudentFields.typeText},
          ${StudentFields.lastName} ${StudentFields.typeText},
          ${StudentFields.studentsYear} ${StudentFields.typeInt}
        )
      ''');
  }

  // insert data
  Future<int> insertStudents(List<Students> students) async {
    int result = 0;

    final Database db = await initializedDB();
    for (var student in students) {
      result = await db.insert(
        StudentFields.tableName,
        student.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return result;
  }

  // retrieve data
  Future<List<Students>> retrieveStudents() async {
    final Database db = await initializedDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      StudentFields.tableName,
    );

    return queryResult.map((e) => Students.fromMap(e)).toList();
  }

  // delete user
  Future<void> deleteStudent(int id) async {
    final db = await initializedDB();
    await db.delete(StudentFields.tableName, where: "id = ?", whereArgs: [id]);
  }
}
