import 'package:centicbid/models/bid.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "bid.db";
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

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, _databaseName),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE bid(id TEXT PRIMARY KEY,user_id TEXT NOT NULL, auction_id TEXT NOT NULL, bid REAL NOT NULL)",
        );
      },
      version: _databaseVersion,
    );
  }

  Future<int> insertBid(List<Bid> bids) async {
    int result = 0;
    final Database? db = await database;
    for (var bid in bids) {
      result = await db!.insert('bid', bid.toMap());
    }
    return result;
  }

  Future<List<Bid>> retrieveBids() async {
    final Database? db = await database;
    final List<Map<String, Object?>> queryResult = await db!.query('bid');
    return queryResult.map((e) => Bid.fromMap(e)).toList();
  }

  Future<void> deleteBid(String id) async {
    final db = await database;
    await db!.delete(
      'bid',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateBid(Bid user) async {
    final db = await database;
    return await db!
        .update('bid', user.toMap(), where: 'uid = ?', whereArgs: [user.id]);
  }
}
