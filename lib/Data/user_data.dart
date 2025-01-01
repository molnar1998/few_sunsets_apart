

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  static String name = '';
  static String partnerName = '';
  static String mood = "Happy";
  static String moodPic = "lib/Assets/Emotions/Happy.png";
  static String myLoveID = '';
  static String id = "";
  static int missCounter = 0;
  static bool partnerCheck = true;
  static var requests = [];
  static List<Map<String, dynamic>> friends = [];
  static int counter = 0;

  // Setter method to update the user's name
  static void updateName(String newName) {
    name = newName;
  }

  static void updateMood(String newMood) {
    mood = newMood;
  }
  static void updateID(String newId){
    id = newId;
  }

  static void updateMyLoveID(String iD) {
    myLoveID = iD;
  }

  static void updateMyLoveName(String name) {
    partnerName = name;
  }

  static void updateMyLoveMissMe(int missMe) {
    missCounter = missMe;
  }

  static void updateLoveCheck(bool check) {
    partnerCheck = check;
  }

  static void updateMoodPic(String newMoodPic){
    moodPic = newMoodPic;
  }

  static void updateRequests(var newRequests){
    if(newRequests != null){
      requests = newRequests;
    }
  }

  static Future<void> updateFriends(List<QueryDocumentSnapshot<Map<String, dynamic>>> newFriends) async {
    bool contain = false;
    if(newFriends.isNotEmpty){
      for(var friend in newFriends){
         Map<String, dynamic> temp = friend.data();
         for(var element in friends){
           if(element['friendId'] == temp['friendId']){
             contain = true;
           }
         }
         if(contain == false){
           friends.add(temp);
         } else {
           contain = false;
         }
      }
    }
  }

  static void updateCounter(var newValue){
    counter = newValue;
  }

  static void incrementCounter() {
    counter++;
  }

  static void clearData(){
    name = '';
    partnerName = '';
    mood = "Happy";
    myLoveID = '';
    id = "";
    missCounter = 0;
    partnerCheck = true;
    moodPic = "lib/Assets/Emotions/Happy.png";
    requests = [];
    friends = [];
    counter = 0;
  }

}