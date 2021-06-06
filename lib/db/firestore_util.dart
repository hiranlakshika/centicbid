import 'package:centicbid/models/auction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Auction getAuctionFromSnapshot(DocumentSnapshot document) {
  return Auction(
      id: (document.data()! as Map)['id'],
      title: (document.data()! as Map)['title'],
      description: (document.data()! as Map)['description'],
      basePrice: (document.data()! as Map)['base_price'],
      latestBid: (document.data()! as Map)['latest_bid'],
      images: (document.data()! as Map)['images'],
      remainingTime: (document.data()! as Map)['remaining_time']);
}

DateTime getTimeFromFireStoreTimeStamp(Timestamp t) {
  return DateTime.fromMicrosecondsSinceEpoch(t.microsecondsSinceEpoch);
}
