import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;
import 'package:todo_app/model/todo_task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(path.join(dbPath, 'todo.db'),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE Todo_Tasks (id INTEGER PRIMARY KEY, title TEXT, category TEXT, date TEXT, startTime TEXT , endTime TEXT, description TEXT)'),
        version: 1);
    return db;
  }

  Future<int> insertTask(TodoTask task) async {
    final db = await _getDatabase();
    return await db.insert('Todo_Tasks', task.toMap());
  }

  Future<List<TodoTask>> getAllTasks() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('Todo_Tasks');
    return List.generate(maps.length, (index) {
      return TodoTask.fromMap(maps[index]);
    });
  }

  Future<int> deleteTask(TodoTask task) async {
    final db = await _getDatabase();
    return await db.delete(
      'Todo_Tasks',
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}
