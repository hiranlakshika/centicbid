import 'package:centicbid/models/bid.dart';
import 'package:flutter/material.dart';

class MyBidsListItem extends StatelessWidget {
  final Bid bid;

  const MyBidsListItem(this.bid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Column(
        children: [
          Text(bid.title),
          Text(bid.description),
        ],
      ),
    );
  }
}
