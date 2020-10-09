import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:TodoApp/model/todo.dart';
import 'dart:io';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  String tblTodo = "todo";
  String colId = "id";
  String colTitle = "title";
  String colPriority = "priority";
  String colDescription = "description";
  String colDate = "date";

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "todos.db";
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblTodo($colId INTEGER PRIMARY KEY, $colTitle VARCHAR(255) NOT NULL, $colDescription TEXT, $colPriority INTEGER CHECK($colPriority > 0 AND $colPriority <=3), $colDate TEXT)");
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.insert(tblTodo, todo.toMap());
    return result;
  }

  Future<List> getTodos() async {
    Database db = await this.db;
    return await db
        .rawQuery('SELECT * from $tblTodo ORDER BY $colPriority ASC');
  }

  Future<int> getCount() async {
    Database db = await this.db;
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) from $tblTodo"));
  }

  Future<int> updateTodo(Todo todo) async {
    Database db = await this.db;
    return await db.update(tblTodo, todo.toMap(),
        where: "$colId = ?", whereArgs: [todo.id]);
  }

  Future<int> deleteTodo(int id) async {
    Database db = await this.db;
    return await db.delete(tblTodo, where: "$colId = ?", whereArgs: [id]);
  }
}
