import 'package:few_sunsets_apart/Data/firebase_service.dart';
import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import '../main.dart'; // Import to access navigator key


class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();

  void initialize() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received a message in the foreground!');
      await FirebaseService().loadData();
    });

    // Handle background and terminated state messages when user taps the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if(message.data['type'] == 'request') {
        await FirebaseService().loadData();
        MyApp.navigatorKey.currentState?.pushNamed('/profile');
      }
    });

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) async {

    });
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // This is where you can handle the background message
  print("Handling a background message: ${message.messageId}");
  if(message.data['type'] == 'request') {
    MyApp.navigatorKey.currentState?.pushNamed('/profile');
  }
  // Add any logic you want to execute while handling the message here.
}
