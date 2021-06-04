import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "centic_bids.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return _instance;
  }

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE AUCTION (
            ID TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            base_price REAL NOT NULL,
            latest_bid REAL,
            image_URL TEXT,
            remaining_time INTEGER NOT NULL,
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row, var table) async {
    Database? db = await DatabaseHelper().database;
    return await db!.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(var table) async {
    Database? db = await DatabaseHelper().database;
    return await db!.query(table);
  }

  Future<int?> queryRowCount(var table) async {
    Database? db = await DatabaseHelper().database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row, var table, var columnId) async {
    Database? db = await DatabaseHelper().database;
    int id = row[columnId];
    return await db!
        .update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id, var table, var columnId) async {
    Database? db = await DatabaseHelper().database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
