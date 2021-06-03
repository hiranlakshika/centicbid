import 'package:centicbid/screens/auction_list.dart';
import 'package:centicbid/screens/bids/my_bids_tab_view.dart';
import 'package:centicbid/screens/sign_in.dart';
import 'package:centicbid/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();

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
              UserAccountsDrawerHeader(
                accountName: Text(
                  "John Doe",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/pacman.png')),
                decoration: BoxDecoration(),
                accountEmail: Text(
                  'admin@unihub.com',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Sign in',
                ),
                leading: Icon(
                  Icons.login,
                ),
                onTap: () => Get.to(() => SignIn()),
              ),
              ListTile(
                title: Text(
                  'My Bids',
                ),
                leading: Icon(
                  Icons.monetization_on_outlined,
                ),
                onTap: () => Get.to(() => MyBids()),
              ),
              ListTile(
                title: Text(
                  'Sign out',
                ),
                leading: Icon(
                  Icons.logout,
                ),
                onTap: () async => await _auth.signOut(),
              ),
            ],
          ),
        ),
      ),
      body: AuctionList(),
    );
  }
}
