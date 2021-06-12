import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

class SendPushService extends GetConnect {
  late String apiKey;
  RemoteConfig remoteConfig = RemoteConfig.instance;

  Future<Response> sendPush(
      {required String deviceToken,
      required String auctionTitle,
      required String auctionId}) async {
    apiKey = remoteConfig.getString('messaging_key');
    bool updated = await remoteConfig.fetchAndActivate();
    var response;
    if (updated) {
      apiKey = remoteConfig.getString('messaging_key');
    }
    response = await post('https://fcm.googleapis.com/fcm/send', {
      "to": deviceToken,
      "notification": {
        "body": "new_bid_body".tr + ' $auctionTitle',
        "title": "new_bid".tr
      },
      "data": {"auction": auctionId}
    }, headers: {
      'Authorization': 'key=$apiKey',
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      print('Success');
    }
    return response;
  }
}
