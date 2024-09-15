// firebase_service.dart

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  CollectionReference usersCollections =
  FirebaseFirestore.instance.collection('users');

  // Change counter value for everyone
  Future<void> resetCounterValues() async{
    FirebaseFirestore.instance.collection('users').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.update({
          'miss_you': 0 //Your new value
        });
      }
    });
  }

  Future<void> sendRequest(String loveID) async {
    // ... (same code for topic and notification data)

    // Prepare the FCM message URL
    final url = Uri.parse('https://fcm.googleapis.com/v1/projects/fewsunsetsapart/messages:send');

    final serverKey = dotenv.env['FCM_SERVER_KEY'] ?? '';

    // Prepare the request headers (including server key)
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $serverKey", // Replace with your Firebase server key
    };

    // Prepare the FCM message body
    final messageBody = {
      'data': {
        'title': 'Love Request!', // Notification title (optional)
        'body': '${UserData.id} wants to be your love!', // Notification message
        'requestingUserID': UserData.id, // Include requesting user ID for love ID user's app
      },
      'to': loveID, // Replace with topic or love ID device token (depending on your approach)
    };

    // Send the FCM message using HTTP POST request
    final response = await http.post(url, headers: headers, body: jsonEncode(messageBody));

    if (response.statusCode == 200) {
      print('Love request sent to: $loveID');
    } else {
      print('Error sending love request: ${response.statusCode}');
    }
  }
}
