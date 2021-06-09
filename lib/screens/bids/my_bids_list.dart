import 'package:centicbid/db/firestore_util.dart';
import 'package:centicbid/db/local_db.dart';
import 'package:centicbid/models/auction.dart';
import 'package:centicbid/models/image.dart' as img;
import 'package:centicbid/screens/bids/my_bids_list_item.dart';
import 'package:flutter/material.dart';
import 'package:centicbid/util.dart';

class MyBidsList extends StatelessWidget {
  final MyBidsType type;
  final db = DatabaseHelper();

  MyBidsList(this.type, {Key? key}) : super(key: key);

  Future<List<Auction>> getBidsByType() async {
    List<Auction> auctions = [];
    List<Auction> bids = [];
    await db.database.whenComplete(() async {
      auctions = await db.retrieveAuctions();
      for (var auction in auctions) {
        List<img.Image> images = await db.retrieveImages(auction.id);
        List<String> imageUrls = [];
        images.forEach((element) {
          imageUrls.add(element.imageUrl);
        });

        bids.add(Auction(
            id: auction.id,
            title: auction.title,
            description: auction.description,
            basePrice: auction.basePrice,
            remainingTime: auction.remainingTime,
            latestBid: auction.latestBid,
            images: imageUrls));
      }
    });

    if (bids.length > 0) {
      List<Auction> modifiedList = [];
      if (type == MyBidsType.Ongoing) {
        modifiedList = bids
            .where((element) =>
                getTimeFromFireStoreTimeStamp(element.remainingTime)
                    .isAfter(DateTime.now()))
            .toList();
      } else if (type == MyBidsType.Won) {
        modifiedList = bids
            .where((element) =>
                getTimeFromFireStoreTimeStamp(element.remainingTime)
                    .isBefore(DateTime.now()))
            .toList();
      } else {
        modifiedList = bids
            .where((element) =>
                getTimeFromFireStoreTimeStamp(element.remainingTime)
                    .isBefore(DateTime.now()))
            .toList();
      }
      return modifiedList;
    }
    return bids;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: getBidsByType(),
        builder: (context, AsyncSnapshot<List<Auction>> snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              !snapshot.hasData) {
            return Container();
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  MyBidsListItem(snapshot.data![index], type),
              itemCount: snapshot.data!.length,
            );
          } else {
            return getLoadingDualRing();
          }
        },
      ),
    );
  }
}
