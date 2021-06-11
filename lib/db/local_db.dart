import 'package:centicbid/models/auction.dart';
import 'package:centicbid/models/image.dart';
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

  String get auctionInsert =>
      "CREATE TABLE auction(id TEXT PRIMARY KEY, title TEXT NOT NULL, description TEXT NOT NULL, uid TEXT, base_price REAL NOT NULL, latest_bid REAL NOT NULL, remaining_time TEXT NOT NULL)";

  String get imageInsert =>
      "CREATE TABLE image(image_url TEXT NOT NULL , auction_id TEXT NOT NULL, PRIMARY KEY(image_url, auction_id))";

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
          auctionInsert,
        );
        await database.execute(
          imageInsert,
        );
      },
      version: _databaseVersion,
    );
  }

  Future deleteLocalDatabase() async {
    final Database? db = await database;
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _databaseName);
    await db!.close();
    _database = null;
    await deleteDatabase(path);
  }

  Future<dynamic> insertAuction(Auction auction, double newBid, String? uid,
      {Database? mockDb}) async {
    Database? db;
    mockDb == null ? db = await database : db = mockDb;
    final batch = db!.batch();
    batch.insert(
        'auction',
        {
          'id': auction.id,
          'title': auction.title,
          'description': auction.description,
          'uid': uid,
          'base_price': auction.basePrice,
          'latest_bid': newBid,
          'remaining_time': auction.remainingTime,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
    for (var image in auction.images!) {
      batch.insert('image', {'image_url': image, 'auction_id': auction.id},
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    return await batch.commit();
  }

  Future<List<Auction>> retrieveAuctions({Database? mockDb}) async {
    Database? db;
    mockDb == null ? db = await database : db = mockDb;
    final List<Map<String, Object?>> queryResult = await db!.query('auction');
    return queryResult.map((e) => Auction.fromMap(e)).toList();
  }

  Future<List<Auction>> retrieveAuction(String id, {Database? mockDb}) async {
    Database? db;
    mockDb == null ? db = await database : db = mockDb;
    final result = await db!.query('auction', where: 'id = ?', whereArgs: [id]);
    return result.map((e) => Auction.fromMap(e)).toList();
  }

  Future<List<Image>> retrieveImages(String auctionId,
      {Database? mockDb}) async {
    Database? db;
    mockDb == null ? db = await database : db = mockDb;
    final result = await db!
        .query('image', where: 'auction_id = ?', whereArgs: [auctionId]);
    return result.map((e) => Image.fromMap(e)).toList();
  }

  Future<int> updateAuction(Auction auction, {Database? mockDb}) async {
    Database? db;
    mockDb == null ? db = await database : db = mockDb;
    return await db!.update('auction', auction.toMap(),
        where: 'id = ?', whereArgs: [auction.id]);
  }
}
