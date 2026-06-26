import 'package:sqflite/sqflite.dart';
import 'package:taskmind_ai/data/database/database_helper.dart';
import 'package:taskmind_ai/data/models/task.dart';

class TaskDao {
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  Future<int> insertTask(Task task) async {
    final Database db = await databaseHelper.database;

    return await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getTasks() async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      orderBy: 'id DESC',
    );

    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> updateTask(Task task) async {
    final Database db = await databaseHelper.database;

    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final Database db = await databaseHelper.database;

    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}