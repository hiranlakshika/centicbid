import 'package:centicbid/db/firestore_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('Firestore timestamp to datetime', () {
    var time = getTimeFromFireStoreTimeStamp(Timestamp.now());
    expect(time, isInstanceOf<DateTime>());
  });
}
