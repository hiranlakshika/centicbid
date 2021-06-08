import 'package:cached_network_image/cached_network_image.dart';
import 'package:centicbid/models/bid.dart';
import 'package:centicbid/util.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class MyBidsListItem extends StatelessWidget {
  final Bid bid;
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
          backgroundImage:
              CachedNetworkImageProvider('http://via.placeholder.com/350x150'),
        ),
        titleText: 'Title',
        subTitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price :'),
            Visibility(
                visible: type == MyBidsType.Ongoing || type == MyBidsType.Lost,
                child: Text('Latest Bid : ')),
            Visibility(
                visible: type == MyBidsType.Ongoing,
                child: Text('Remaining Time :')),
          ],
        ),
      ),
      content: Text("Some quick example text to build on the card"),
      buttonBar: GFButtonBar(
        children: <Widget>[
          Visibility(
            visible: type != MyBidsType.Lost,
            child: GFButton(
              onPressed: () {},
              text: 'View',
            ),
          )
        ],
      ),
    );
  }
}
