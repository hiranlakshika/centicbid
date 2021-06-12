import 'package:centicbid/db/local_db.dart';
import 'package:centicbid/models/auction.dart';
import 'package:centicbid/models/bid.dart';
import 'package:centicbid/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class FirestoreController extends GetxController {
  static FirestoreController to = Get.find();
  CollectionReference _bids = FirebaseFirestore.instance.collection('bids');
  CollectionReference _auction =
      FirebaseFirestore.instance.collection('auction');
  CollectionReference _user = FirebaseFirestore.instance.collection('user');

  Future<void> addBid(Bid bid) {
    return _bids
        .add({
          'user_id': bid.userId,
          'auction_id': bid.auctionId,
          'bid': bid.bid,
        })
        .then((value) => print("Bid Added"))
        .catchError((error) => print("Failed to add bid: $error"));
  }

  Future<void> addUser(String uid, String token) async {
    String? userDocId = await getUserDocId(uid);
    if (userDocId != null) {
      await updateDeviceToken(token, userDocId);
    } else {
      return _user
          .add({'uid': uid, 'token': token})
          .then((value) => print('User Added'))
          .catchError((error) => print("Failed to add user: $error"));
    }
  }

  Future<void> updateAuctionValues(double bid, String documentId, String uid) {
    return _auction
        .doc(documentId)
        .update({'latest_bid': bid, 'uid': uid})
        .then((value) => print('Auction updated'))
        .catchError((error) => print("Failed to update auction: $error"));
  }

  Future<String?> getUserDocId(String uid) async {
    String? userDocId;
    await _user
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        userDocId = querySnapshot.docs[0].id;
      }
    });
    return userDocId;
  }

  Future<User?> getUser(String uid) async {
    User? user;
    await _user
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        user =
            User(querySnapshot.docs[0]['uid'], querySnapshot.docs[0]['token']);
      }
    });
    return user;
  }

  Future<void> updateDeviceToken(String token, String documentId) {
    return _user
        .doc(documentId)
        .update({'token': token})
        .then((value) => print('User updated'))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future getBids(String? userId) async {
    var db = DatabaseHelper();
    await _bids
        .where('user_id', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        Auction? auc = await getAuction(doc["auction_id"]);
        var output = db.database.whenComplete(() async => await db
            .insertAuction(auc!, doc["bid"], auc.uid)
            .onError((error, stackTrace) => print(error)));
      });
    });
  }

  Future<Auction?> getAuction(String documentId) async {
    Auction? auc;

    await _auction
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
      uid: (document.data()! as Map)['uid'],
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
