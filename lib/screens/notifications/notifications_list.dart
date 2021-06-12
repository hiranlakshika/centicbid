import 'package:centicbid/controllers/auth_controller.dart';
import 'package:centicbid/db/firestore_util.dart';
import 'package:centicbid/screens/item_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:get/get.dart';
import '../../util.dart';

class NotificationsList extends StatelessWidget {
  NotificationsList({Key? key}) : super(key: key);
  final AuthController _authController = AuthController.to;
  final FirestoreController _firestoreController = FirestoreController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('notifications'.tr),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('notifications')
              .where('uid', isEqualTo: _authController.firebaseUser.value!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return getLoadingDualRing();
            } else {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return Card(
                    elevation: 1.0,
                    child: GFListTile(
                      onTap: () async {
                        String auctionId =
                            (document.data()! as Map)['auction_id'];
                        var auction =
                            await _firestoreController.getAuction(auctionId);
                        Get.to(() => ItemDetails(auction!));
                      },
                      titleText: (document.data()! as Map)['title'],
                      subTitleText: (document.data()! as Map)['body'],
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
