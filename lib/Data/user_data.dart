

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/friend.dart';

class UserData {
  static String name = '';
  static String partnerName = '';
  static String mood = "Happy";
  static String moodPic = "lib/Assets/Emotions/Happy.png";
  static var profilePic = "lib/Assets/Images/3.png";
  static String myLoveID = '';
  static String id = "";
  static int missCounter = 0;
  static bool partnerCheck = true;
  static var requests = [];
  static List<Friend> friends = [];
  static int counter = 0;
  static bool darkMode = false;

  // Setter method to update the user's name
  static void updateName(String newName) {
    name = newName;
  }

  static void updateMood(var newMood) {
    if(newMood != null){
      mood = newMood;
    }
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

  static void updateMoodPic(var newMoodPic){
    if(newMoodPic != null){
      moodPic = newMoodPic;
    }
  }

  static void updateRequests(var newRequests){
    if(newRequests != null){
      requests = newRequests;
    }
  }

  static Future<void> updateFriends(List<QueryDocumentSnapshot<Map<String, dynamic>>> newFriends) async {
    if(newFriends.isNotEmpty){
      for(var friend in newFriends){
         Friend temp = Friend(friendId: friend['friendId'], friendUId: friend['friendUId'], timestamp: friend['timestamp']);
         bool contain = friends.any((element) => element.friendId == temp.friendId);
         if(contain == false){
           friends.add(temp);
         } else {
           contain = false;
         }
      }
    }
  }

  static void updateDarkMode(bool newValue){
    darkMode = newValue;
  }

  static void updateProfilePic(var newProfilePic){
    if(newProfilePic != null){
      profilePic = newProfilePic;
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
    profilePic = "lib/Assets/Images/3.png";
    requests = [];
    friends = [];
    counter = 0;
    darkMode = false;
  }

}