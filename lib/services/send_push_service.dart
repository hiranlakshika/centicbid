import 'package:get/get_connect/connect.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class SendPushService extends GetConnect {
  late String apiKey;
  RemoteConfig remoteConfig = RemoteConfig.instance;

  Future<Response> sendPush(
      {required String deviceToken,
      required String auctionTitle,
      required String auctionId}) async {
    bool updated = await remoteConfig.fetchAndActivate();
    var response;
    if (updated) {
      apiKey = remoteConfig.getString('messaging_key');
      response = await post('https://fcm.googleapis.com/fcm/send', {
        "to": deviceToken,
        "notification": {
          "body": "Someone else has placed a higher bid for $auctionTitle",
          "title": "New Bid"
        },
        "data": {"auction": auctionId}
      }, headers: {
        'Authorization': 'key=$apiKey',
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200) {
        print('Success');
      }
    }
    return response;
  }
}
