import 'package:centicbid/models/auction.dart';
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
                var auction = Auction(
                    id: (document.data()! as Map)['id'],
                    title: (document.data()! as Map)['title'],
                    description: (document.data()! as Map)['description'],
                    basePrice: (document.data()! as Map)['base_price'],
                    latestBid: (document.data()! as Map)['latest_bid'],
                    images: (document.data()! as Map)['images'],
                    remainingTime: (document.data()! as Map)['remaining_time']);
                return AuctionListItem(auction);
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
