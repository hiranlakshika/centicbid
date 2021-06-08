import 'package:centicbid/models/bid.dart';
import 'package:flutter/material.dart';
import 'package:centicbid/util.dart';
import 'my_bids_list_item.dart';

class MyBidsList extends StatelessWidget {
  final MyBidsType type;
  final List<Bid> bids = [
    Bid(id: 'id', userId: 'title', auctionId: 'description', bid: 1),
    Bid(id: 'id', userId: 'title', auctionId: 'description', bid: 2)
  ];

  MyBidsList(this.type, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: bids.length,
        itemBuilder: (context, index) {
          return MyBidsListItem(bids[index], type);
        },
      ),
    );
  }
}
