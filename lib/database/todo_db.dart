import 'package:sqflite/sqflite.dart';
import 'package:todolist/models/todo.dart';
import 'database_services.dart';

class TodoDB {
  final tableName = 'todos';

  Future<void> createTable(Database database) async {
    await database.execute("""
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER NOT NULL,
      title TEXT NOT NULL,
      created_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s', 'now') AS INTEGER)),
      updated_at INTEGER,
      PRIMARY KEY ('id' AUTOINCREMENT)
    )
  """);
  }

  Future<int> create({required String title}) async {
    final database = await DatabaseServices().database;
    return await database.rawInsert(
      """INSERT INTO $tableName (title, created_at, updated_at) VALUES (?,?, ?)""",
      [title, DateTime.now().millisecondsSinceEpoch, DateTime.now().millisecondsSinceEpoch],
    );
  }

  Future<void> deleteAllData() async {
    final database = await DatabaseServices().database;
    await database.delete(tableName);
  }

  Future<List<Todo>> fetchAll() async {
    final database = await DatabaseServices().database;
    final todos = await database.rawQuery(
        """ SELECT * FROM $tableName ORDER BY COALESCE(updated_at, created_at)""");
    return todos.map((todo) => Todo.fromSqfliteDatabase(todo)).toList();
  }

  Future<Todo> fetchById(int id) async {
    final database = await DatabaseServices().database;
    final todo = await database
        .rawQuery("""SELECT * FROM $tableName WHERE ID = ? """, [id]);
    return Todo.fromSqfliteDatabase(todo.first);
  }

  Future<int> update({required int id, String? title}) async {
    final database = await DatabaseServices().database;
    return await database.update(
      tableName,
      {
        if (title != null) 'title': title,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ? ',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final database = await DatabaseServices().database;
    await database.rawDelete(""" DELETE FROM $tableName WHERE id = ? """, [id]);
  }
}
