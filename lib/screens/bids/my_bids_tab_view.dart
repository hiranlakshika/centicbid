import 'package:flutter/material.dart';
import '../../util.dart';
import 'my_bids_list.dart';

class MyBids extends StatelessWidget {
  const MyBids({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Bids'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Ongoing'),
              Tab(text: 'Won'),
              Tab(text: 'Lost'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyBidsList(MyBidsType.Ongoing),
            MyBidsList(MyBidsType.Won),
            MyBidsList(MyBidsType.Lost),
          ],
        ),
      ),
    );
  }
}
