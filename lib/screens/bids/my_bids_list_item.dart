import 'package:cached_network_image/cached_network_image.dart';
import 'package:centicbid/db/firestore_util.dart';
import 'package:centicbid/models/auction.dart';
import 'package:centicbid/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:getwidget/getwidget.dart';
import 'package:get/get.dart';

class MyBidsListItem extends StatelessWidget {
  final Auction bid;
  final MyBidsType type;

  const MyBidsListItem(this.bid, this.type, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GFCard(
      elevation: 2.0,
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      imageOverlay: CachedNetworkImageProvider(''),
      title: GFListTile(
        avatar: GFAvatar(
          size: 50.0,
          shape: GFAvatarShape.standard,
          backgroundImage: CachedNetworkImageProvider(bid.images![0]),
        ),
        titleText: bid.title,
        subTitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('price'.tr + ' : ' + bid.basePrice.toString()),
            Visibility(
                visible: type == MyBidsType.Ongoing || type == MyBidsType.Lost,
                child:
                    Text('latest_bid'.tr + ' : ' + bid.latestBid.toString())),
            Visibility(
                visible: type == MyBidsType.Ongoing,
                child: Column(
                  children: [
                    Text('remaining_time'.tr + ' :'),
                    CountdownTimer(
                      endTime: getTimeFromFireStoreTimeStamp(bid.remainingTime)
                              .millisecondsSinceEpoch +
                          1000 * 30,
                      endWidget: Text('expired'.tr),
                    ),
                  ],
                )),
          ],
        ),
      ),
      content: Text(bid.description),
      buttonBar: GFButtonBar(
        children: <Widget>[
          Visibility(
            visible: type != MyBidsType.Lost,
            child: GFButton(
              onPressed: () {},
              text: 'view'.tr,
            ),
          )
        ],
      ),
    );
  }
}
