import 'package:task_list_sqflite/data/database_helper.dart';
import 'package:task_list_sqflite/models/task.dart';

class TaskManager {
  final DatabaseHelper _databaseHelper;

  TaskManager(this._databaseHelper);

  Future<List<Task>> getTasks() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
  }

  Future addTask(Task task) async {
    final db = await _databaseHelper.database;
    await db.insert('tasks', task.toMap());
  }

  Future editTask(Task task) async {
    final db = await _databaseHelper.database;
    await db
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future finishTask(Task task) async {
    final db = await _databaseHelper.database;
    if (task.isDone) {
      await db
          .rawUpdate('UPDATE tasks SET is_done = ? WHERE id = ?', [0, task.id]);
    } else {
      await db
          .rawUpdate('UPDATE tasks SET is_done = ? WHERE id = ?', [1, task.id]);
    }
  }

  deleteTask(int id) async {
    final db = await _databaseHelper.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
