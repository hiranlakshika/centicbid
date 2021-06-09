import 'package:centicbid/db/firestore_util.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('Firestore timestamp to datetime', () {
    var time = getTimeFromFireStoreTimeStamp('1623349800');
    expect(time, isInstanceOf<DateTime>());
  });
}
