// firebase_service.dart

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  CollectionReference usersCollections =
  FirebaseFirestore.instance.collection('users');


  // Save counter value to Firestore
  Future<void> saveCounterValue(int value) async {
    try {
      await usersCollections.doc(UserData.id).set({'miss_you': value}, SetOptions(merge: true));
      debugPrint('Counter value saved successfully!');
    } catch (e) {
      debugPrint('Error saving counter value: $e');
    }
  }

  // Save friend ID value to Firestore
  Future<void> saveLoveIDValue(String value) async {
    try{
      await usersCollections.doc(UserData.id).set({'my_love_ID': value}, SetOptions(merge: true));
      debugPrint('Friend ID value saved successfully!');
    } catch (e) {
      debugPrint('Error saving counter value: $e');
    }
  }

  // Save mood value to Firestore
  Future<void> saveMoodValue(String value) async {
    try{
      await usersCollections.doc(UserData.id).set({'my_mood': value}, SetOptions(merge: true));
      debugPrint('Mood value saved successfully!');
    } catch (e) {
      debugPrint('Error saving counter value: $e');
    }
  }

  // Save mood value to Firestore
  Future<void> saveData(String fieldName, String value) async {
    try{
      await usersCollections.doc(UserData.id).set({fieldName : value}, SetOptions(merge: true));
      debugPrint('Data saved successfully!');
    } catch (e) {
      debugPrint('Error saving data: $e');
    }
  }

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

  // Retrieve Data value from Firestore
  Stream<int> getIntData(String userID, String field) {
    return usersCollections.doc(userID).snapshots().map((snapshot) {
      var counterData = snapshot.data() as Map<String, dynamic>;
      if(counterData[field] == null){
        throw Future.error("Field is not existing");
      }
      return counterData[field] as int? ?? 0; // Explicit cast
    });
  }

  // Retrieve Data from Firestore
  Stream<String> getStringData(String userID, String field) {
    try{
      return usersCollections.doc(userID).snapshots().map((snapshot) {
        var data = snapshot.data() as Map<String, dynamic>;
        return data[field];
      });
    } catch(e){
      rethrow;
    }
  }

  Future<void> sendLoveRequest(String loveID) async {
    // ... (same code for topic and notification data)

    // Prepare the FCM message URL
    final url = Uri.parse('https://fcm.googleapis.com/v1/messages:send');

    // Prepare the request headers (including server key)
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=AIzaSyBK9rbhlYMHwM2QG7VHQpXDQBR6NR8SL3Y', // Replace with your Firebase server key
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
