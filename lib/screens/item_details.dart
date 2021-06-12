import 'package:cached_network_image/cached_network_image.dart';
import 'package:centicbid/controllers/auth_controller.dart';
import 'package:centicbid/db/firestore_util.dart';
import 'package:centicbid/db/local_db.dart';
import 'package:centicbid/models/auction.dart';
import 'package:centicbid/models/bid.dart';
import 'package:centicbid/models/user.dart';
import 'package:centicbid/screens/sign_in.dart';
import 'package:centicbid/services/send_push_service.dart';
import 'package:centicbid/theme/styles.dart';
import 'package:centicbid/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:sqflite/sqflite.dart';

class ItemDetails extends StatefulWidget {
  final Auction auction;

  ItemDetails(this.auction, {Key? key}) : super(key: key);

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  int _currentImage = 0;
  double _bidValue = 0;
  AuthController _controller = AuthController.to;
  late DateTime _remainingTime;
  late FirestoreController _firestoreControllers;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Widget carousel() {
    return GFCarousel(
      autoPlay: false,
      activeIndicator: Colors.blue,
      enableInfiniteScroll: false,
      items: widget.auction.images!.map(
        (url) {
          return Container(
            margin: EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: CachedNetworkImage(
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
                imageUrl: url,
                fit: BoxFit.cover,
                width: 1000.0,
              ),
            ),
          );
        },
      ).toList(),
      onPageChanged: (index) {
        setState(() {
          _currentImage = index;
        });
      },
    );
  }

  Widget carouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: map<Widget>(widget.auction.images!, (index, url) {
        return Container(
          width: 10.0,
          height: 10.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentImage == index ? Colors.blueAccent : Colors.black12,
          ),
        );
      }),
    );
  }

  addLocalAuctionRecord(Auction auction, double newBid) async {
    final db = DatabaseHelper();
    try {
      await db.database.whenComplete(() async {
        final result = await db.retrieveAuction(auction.id);
        if (result.length == 0) {
          await db.insertAuction(
              auction, newBid, _controller.firebaseUser.value!.uid);
        } else {
          Auction newAuction = Auction(
              id: auction.id,
              title: auction.title,
              description: auction.description,
              uid: _controller.firebaseUser.value!.uid,
              basePrice: auction.basePrice,
              remainingTime: auction.remainingTime,
              latestBid: newBid);
          await db.database.whenComplete(() => db.updateAuction(newAuction));
        }
      });
    } on DatabaseException {
      showErrorToast('error'.tr);
    }
  }

  Future<Response> sendPushMessage() async {
    var response;
    if (widget.auction.uid!.isNotEmpty &&
        widget.auction.uid != _controller.firebaseUser.value!.uid) {
      User? lastBidder =
          await _firestoreControllers.getUser(widget.auction.uid ?? '');
      SendPushService pushService = Get.put(SendPushService());
      response = await pushService.sendPush(
          deviceToken: lastBidder!.deviceToken,
          auctionTitle: widget.auction.title,
          auctionId: widget.auction.id);
    }
    return response;
  }

  addFirestoreBidRecord(Bid bid) async {
    try {
      await _firestoreControllers.addBid(bid);
      await _firestoreControllers.updateAuctionValues(
          _bidValue, widget.auction.id, _controller.firebaseUser.value!.uid);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'enter_bid'.tr,
              textAlign: TextAlign.center,
            ),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _bidValue = double.parse(value);
                }
              },
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  child: Text('ok'.tr),
                  onPressed: () async {
                    if (_bidValue <= widget.auction.latestBid ||
                        _bidValue < widget.auction.basePrice) {
                      showErrorToast('bid_value_should_be_greater'.tr);
                    } else {
                      Bid bid = Bid(
                          userId: _controller.firebaseUser.value!.uid,
                          auctionId: widget.auction.id,
                          bid: _bidValue);
                      await addLocalAuctionRecord(widget.auction, _bidValue);
                      await sendPushMessage();
                      await addFirestoreBidRecord(bid);
                    }
                    Get.back();
                  },
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    _remainingTime =
        getTimeFromFireStoreTimeStamp(widget.auction.remainingTime);
    _firestoreControllers = Get.put(FirestoreController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('item_details'.tr),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          carousel(),
          carouselIndicator(),
          SizedBox(
            height: 10.0,
          ),
          Text(
            widget.auction.title,
            style: titleTextStyle,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text('price'.tr + ' : ' + widget.auction.basePrice.toString()),
          SizedBox(
            height: 10.0,
          ),
          Text('latest_bid'.tr + ' : ' + widget.auction.latestBid!.toString()),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('remaining_time'.tr + ' : '),
              CountdownTimer(
                endTime: _remainingTime.millisecondsSinceEpoch + 1000 * 30,
                endWidget: Text('expired'.tr),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Visibility(
            visible: _remainingTime.isAfter(DateTime.now()),
            child: ElevatedButton(
              onPressed: () {
                if (_controller.firebaseUser.value == null) {
                  showInfoToast('user_needs_to_sign_in'.tr);
                  Get.to(() => SignIn(
                        fromHome: false,
                      ));
                } else {
                  _displayTextInputDialog(context);
                }
              },
              child: Text('place_bid'.tr),
            ),
          ),
        ],
      ),
    );
  }
}
