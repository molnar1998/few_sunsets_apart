import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../main.dart'; // Import to access navigator key

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();

  void initialize() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received a message in the foreground!');
      if(message.data['type'] == 'request'){
        await _dataFetcher.saveRequest(UserData.id, message.data['partnerID']);
      }
    });

    // Handle background and terminated state messages when user taps the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToMessagesPage(message);  // Check this method call for exact casing
    });

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _navigateToMessagesPage(message);  // Check this method call for exact casing
      }
    });
  }

  void _navigateToMessagesPage(RemoteMessage message) {
    MyApp.navigatorKey.currentState?.pushNamed('/messages_page');
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // This is where you can handle the background message
    print("Handling a background message: ${message.messageId}");
    // Add any logic you want to execute while handling the message here.
  }
}
