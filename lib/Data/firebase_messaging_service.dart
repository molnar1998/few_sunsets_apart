import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:few_sunsets_apart/Data/firebase_service.dart';
import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import '../main.dart';
import '../Models/message.dart'; // Import to access navigator key


class FirebaseMessagingService extends ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      createdAt: timestamp,
      message: message,
    );

    // construct chat room id from current user id and receiver id (stored to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids
    String chatRoomId = ids.join("_");

    // add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId).collection('messages')
        .add(newMessage.toMap());
  }

  // GET MESSAGES
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    var Snapshot = _firestore
        .collection('chat_rooms')
        .doc(chatRoomId).collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots();

    return Snapshot;
  }

  // GET LAST MESSAGES
  Stream<String> getLastMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId).collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot){
          // Get the last document in the list if it exists
          if(snapshot.docs.isNotEmpty) {
            var lastMessageDoc = snapshot.docs.last;
            return lastMessageDoc['message'];
          } else {
            return "";
          }
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
