import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseFCM {
  Future<void> sendRequest(String loveID) async {
    final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
  }
}