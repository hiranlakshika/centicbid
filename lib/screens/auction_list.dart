import 'package:centicbid/db/firestore_util.dart';
import 'package:centicbid/screens/auction_list_item.dart';
import 'package:centicbid/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuctionList extends StatefulWidget {
  const AuctionList({Key? key}) : super(key: key);

  @override
  _AuctionListState createState() => _AuctionListState();
}

class _AuctionListState extends State<AuctionList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('auction').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return getLoadingDualRing();
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return AuctionListItem(getAuctionFromSnapshot(document));
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
