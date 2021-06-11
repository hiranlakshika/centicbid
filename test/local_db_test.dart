import 'package:centicbid/db/local_db.dart';
import 'package:centicbid/models/auction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Auction getNewAuction(double latestBid) {
  List<String> imageList = ['image1', 'image2'];
  return Auction(
      id: '1',
      remainingTime: '10',
      basePrice: 1000,
      description: 'Test',
      title: 'Test1',
      uid: '123',
      images: imageList,
      latestBid: latestBid);
}

main() {
  sqfliteFfiInit();
  var dbHelper = DatabaseHelper();
  group('Local database test', () {
    test('DB version test', () async {
      var db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      expect(await db.getVersion(), 0);
      await db.close();
    });

    test('DB creation test', () async {
      var databaseFactory = databaseFactoryFfi;
      var db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db.execute(dbHelper.auctionInsert);
      await db.execute(dbHelper.imageInsert);
      await dbHelper.insertAuction(getNewAuction(5000), 5000, '123',
          mockDb: db);

      dynamic result = await dbHelper.retrieveAuctions(mockDb: db);
      print('Auctions length ' + result.length.toString());
      expect(result.length, greaterThan(0));

      result = await dbHelper.retrieveImages('1', mockDb: db);
      print('Images length ' + result.length.toString());
      expect(result.length, greaterThan(0));

      result = await dbHelper.updateAuction(getNewAuction(5001), mockDb: db);
      expect(result, greaterThan(0));
      result = await dbHelper.retrieveAuction('1', mockDb: db);
      print('Auction length ' + result.length.toString());
      expect(result.length, greaterThan(0));
      print('Latest bid ' + result[0]!.latestBid.toString());
      expect(result[0]!.latestBid, equals(5001));

      await db.close();
    });
  });
}
