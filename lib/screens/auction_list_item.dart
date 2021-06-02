import 'package:cached_network_image/cached_network_image.dart';
import 'package:centicbid/models/auction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'item_details.dart';

class AuctionListItem extends StatelessWidget {
  final Auction auction;

  const AuctionListItem(this.auction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Row(
        children: [
          CachedNetworkImage(
            width: 100.0,
            height: 100.0,
            imageUrl: auction.imageUrl ?? 'http://via.placeholder.com/350x150',
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Column(
            children: [
              Text(auction.title),
              Text(auction.description),
              Text(auction.basePrice.toString()),
              Text(auction.latestBid?.toString() ?? ''),
              CountdownTimer(
                endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 10,
                endWidget: Text('Expired'),
              ),
              ElevatedButton(
                onPressed: () => Get.to(() => ItemDetails()),
                child: Text('Bid Now'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
