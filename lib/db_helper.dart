import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'model/user.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static const String dbName = 'fasting2.db';
  static const String tableName = 'fastingDB'; // New constant for table name

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, dbName);
    print(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        missedDay INTEGER,
        makeupDay INTEGER
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    Database db = await instance.database;
    return await db.insert(tableName, {
      'name': user.name,
      'missedDay': user.missedFast,
      'makeupDay': user.makeupDay
    });
  }

  Future<List<User>> getUser() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(tableName);

    List<User> users = result.map((map) => User.fromMap(map)).toList();
    return users;
  }

  Future<int> updateUser(int id, User user) async {
    Database db = await instance.database;
    return await db.update(
        tableName,
        {
          'name': user.name,
          'missedDay': user.missedFast,
          'makeupDay': user.makeupDay
        },
        where: 'id = ?',
        whereArgs: [id]);
  }

  Future<int> deleteUser(int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // New method to delete the entire database
  Future<void> customDeleteDatabase() async {
    var documentsDirectory = await getDatabasesPath();
    var path = join(documentsDirectory, dbName);
    await deleteDatabase(path);
    _database = null; // Set _database to null after deletion
  }

  Future<int> deleteAllUsers() async {
    Database db = await instance.database;
    return await db.delete(tableName); // tableName is the name of your table
  }
}
