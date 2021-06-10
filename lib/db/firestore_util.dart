import 'package:centicbid/db/local_db.dart';
import 'package:centicbid/models/auction.dart';
import 'package:centicbid/models/bid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';

class FirestoreController {
  static FirestoreController to = Get.find();
  CollectionReference bids = FirebaseFirestore.instance.collection('bids');
  CollectionReference auction =
      FirebaseFirestore.instance.collection('auction');

  Future<void> addBid(Bid bid) {
    return bids
        .add({
          'user_id': bid.userId,
          'auction_id': bid.auctionId,
          'bid': bid.bid,
        })
        .then((value) => print("Bid Added"))
        .catchError((error) => print("Failed to add bid: $error"));
  }

  Future<void> updateBidValue(double bid, String documentId) {
    return auction
        .doc(documentId)
        .update({'latest_bid': bid})
        .then((value) => print('Auction updated'))
        .catchError((error) => print("Failed to add bid: $error"));
  }

  Future getBids(String? userId) async {
    var db = DatabaseHelper();
    await FirebaseFirestore.instance
        .collection('bids')
        .where('user_id', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        print(doc["bid"]);
        print(doc["auction_id"]);
        Auction? auc = await getAuction(doc["auction_id"]);
        var output = db.database.whenComplete(() async => await db
            .insertAuction(auc!, doc["bid"])
            .onError((error, stackTrace) => print(error)));
      });
    });
  }

  Future<Auction?> getAuction(String documentId) async {
    Auction? auc;

    await auction
        .doc(documentId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        auc = getAuctionFromSnapshot(documentSnapshot);
      }
    });
    return auc;
  }
}

Auction getAuctionFromSnapshot(DocumentSnapshot document) {
  return Auction(
      id: document.id,
      title: (document.data()! as Map)['title'],
      description: (document.data()! as Map)['description'],
      basePrice: (document.data()! as Map)['base_price'],
      latestBid: (document.data()! as Map)['latest_bid'],
      images: (document.data()! as Map)['images'],
      remainingTime: (document.data()! as Map)['remaining_time']
          .microsecondsSinceEpoch
          .toString());
}

DateTime getTimeFromFireStoreTimeStamp(String t) {
  return DateTime.fromMicrosecondsSinceEpoch(int.parse(t));
}
