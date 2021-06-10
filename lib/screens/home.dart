import 'package:centicbid/controllers/auth_controller.dart';
import 'package:centicbid/screens/auction_list.dart';
import 'package:centicbid/screens/bids/my_bids_tab_view.dart';
import 'package:centicbid/screens/sign_in.dart';
import 'package:centicbid/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final AuthController _controller = Get.put(AuthController());

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Container(
        width: 260.0,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Obx(() {
                if (_controller.firebaseUser.value != null) {
                  return UserAccountsDrawerHeader(
                    currentAccountPicture:
                        Image.asset('assets/images/profile.png'),
                    accountName: Text(
                      _controller.firebaseUser.value!.displayName ?? '',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    decoration: BoxDecoration(),
                    accountEmail: Text(
                      _controller.firebaseUser.value!.email.toString(),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  return UserAccountsDrawerHeader(
                    accountEmail: Text(''),
                    accountName: Text(''),
                  );
                }
              }),
              Obx(() {
                if (_controller.firebaseUser.value == null) {
                  return ListTile(
                    title: Text(
                      'sign_in'.tr,
                    ),
                    leading: Icon(
                      Icons.login,
                    ),
                    onTap: () => Get.to(() => SignIn(
                          fromHome: true,
                        )),
                  );
                } else {
                  return Container();
                }
              }),
              Obx(() {
                if (_controller.firebaseUser.value != null) {
                  return ListTile(
                    title: Text(
                      'my_bids'.tr,
                    ),
                    leading: Icon(
                      Icons.monetization_on_outlined,
                    ),
                    onTap: () => Get.to(() => MyBids()),
                  );
                } else {
                  return Container();
                }
              }),
              Obx(() {
                if (_controller.firebaseUser.value != null) {
                  return ListTile(
                    title: Text(
                      'sign_out'.tr,
                    ),
                    leading: Icon(
                      Icons.logout,
                    ),
                    onTap: () async {
                      await _controller.signOut();
                      showInfoToast('user_signed_out'.tr);
                    },
                  );
                } else {
                  return Container();
                }
              }),
            ],
          ),
        ),
      ),
      body: AuctionList(),
    );
  }
}
