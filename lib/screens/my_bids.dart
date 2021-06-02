import 'package:flutter/material.dart';

class MyBids extends StatelessWidget {
  const MyBids({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bids'),
        centerTitle: true,
      ),
    );
  }
}
