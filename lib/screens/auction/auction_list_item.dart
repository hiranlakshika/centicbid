import 'package:cached_network_image/cached_network_image.dart';
import 'package:centicbid/db/firestore_util.dart';
import 'package:centicbid/models/auction.dart';
import 'package:centicbid/theme/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import '../item_details.dart';
import 'package:getwidget/getwidget.dart';

class AuctionListItem extends StatelessWidget {
  final Auction auction;

  const AuctionListItem(this.auction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: GFListTile(
        avatar: GFAvatar(
          size: 70.0,
          backgroundImage: CachedNetworkImageProvider(
              auction.images?[0] ?? 'http://via.placeholder.com/350x150'),
          shape: GFAvatarShape.standard,
        ),
        subTitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              auction.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'price'.tr + ' :' + auction.basePrice.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'latest_bid'.tr + ' :' + auction.latestBid!.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 5.0,
            ),
            CountdownTimer(
              endTime: getTimeFromFireStoreTimeStamp(auction.remainingTime)
                      .millisecondsSinceEpoch +
                  1000 * 30,
              endWidget: Text('expired'.tr),
            )
          ],
        ),
        title: Text(
          auction.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: titleTextStyle,
        ),
        icon: Visibility(
          visible: getTimeFromFireStoreTimeStamp(auction.remainingTime)
              .isAfter(DateTime.now()),
          child: ElevatedButton(
            onPressed: () => Get.to(() => ItemDetails(auction)),
            child: Text('bid_now'.tr),
          ),
        ),
      ),
    );
  }
}
