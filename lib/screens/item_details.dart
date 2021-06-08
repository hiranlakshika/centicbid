import 'package:cached_network_image/cached_network_image.dart';
import 'package:centicbid/controllers/auth_controller.dart';
import 'package:centicbid/db/firestore_util.dart';
import 'package:centicbid/db/local_db.dart';
import 'package:centicbid/models/auction.dart';
import 'package:centicbid/models/bid.dart';
import 'package:centicbid/screens/home.dart';
import 'package:centicbid/screens/sign_in.dart';
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

  addLocalBidRecord(Bid bid) async {
    final db = DatabaseHelper();

    List<Bid> bidList = [bid];
    try {
      await db.database.whenComplete(() => db.insertBid(bidList));
    } on DatabaseException {
      showErrorToast('Error');
    }
  }

  addLocalAuctionRecord() async {
    final db = DatabaseHelper();
  }

  addFirestoreBidRecord(Bid bid) async {
    FirestoreController fs = Get.put(FirestoreController());
    try {
      await fs.addBid(bid);
      await fs.updateBidValue(_bidValue, widget.auction.id);
    } catch (e) {
      print(e);
    } finally {
      print('test');
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Enter your bid value',
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
                  child: Text('OK'),
                  onPressed: () async {
                    if (_bidValue <= widget.auction.latestBid ||
                        _bidValue < widget.auction.basePrice) {
                      showErrorToast(
                          'Your bid value should be greater than current bid value and price');
                    } else {
                      Bid bid = Bid(
                          id: _controller.firebaseUser.value!.uid +
                              widget.auction.id +
                              (_bidValue.toString()),
                          userId:
                              _controller.firebaseUser.value!.email.toString(),
                          auctionId: widget.auction.id,
                          bid: _bidValue);
                      await addLocalBidRecord(bid);
                      await addFirestoreBidRecord(bid);
                    }
                    Get.off(() => Home());
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
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
          Text('Price : ' + widget.auction.basePrice.toString()),
          SizedBox(
            height: 10.0,
          ),
          Text('Latest Bid : ' + widget.auction.latestBid!.toString()),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Remaining Time : '),
              CountdownTimer(
                endTime: _remainingTime.millisecondsSinceEpoch + 1000 * 30,
                endWidget: Text('Expired'),
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
                  showInfoToast('You need to sign in to place a bid');
                  Get.to(() => SignIn());
                } else {
                  _displayTextInputDialog(context);
                }
              },
              child: Text('Place bid'),
            ),
          ),
        ],
      ),
    );
  }
}
