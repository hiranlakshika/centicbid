import 'package:centicbid/models/auction.dart';
import 'package:centicbid/screens/auction_list_item.dart';
import 'package:flutter/material.dart';

class AuctionList extends StatefulWidget {
  const AuctionList({Key? key}) : super(key: key);

  @override
  _AuctionListState createState() => _AuctionListState();
}

class _AuctionListState extends State<AuctionList> {
  List<Auction> auctions = [
    Auction('title', 'description', 90.0, 100.0, null, 100000),
    Auction('title', 'description', 90.0, 100.0, null, 100),
    Auction('title', 'description', 90.0, 100.0, null, 100),
    Auction('title', 'description', 90.0, 100.0, null, 100),
    Auction('title', 'description', 90.0, 100.0, null, 100),
    Auction('title', 'description', 90.0, 100.0, null, 100),
    Auction('title', 'description', 90.0, 100.0, null, 100)
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: auctions.length,
          itemBuilder: (context, index) {
            return AuctionListItem(auctions[index]);
          }),
    );
  }
}
