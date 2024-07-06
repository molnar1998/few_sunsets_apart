import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  // Data members for user information
  String? uid;
  String? name;
  String? myLoveName;
  String? mood;
  String? myLoveID;
  int? myLoveMissMe;

  // Function to update user data
  void updateUserData(Map<String, dynamic> data) {
    name = data['my_name'];
    myLoveID = data['my_love_ID'];
    mood = data['my_mood'];
    notifyListeners(); // Notify listeners of changes
  }

  // Function to clear user data (for logout)
  void clearUserData() {
    uid = null;
    name = null;
    myLoveName = null;
    mood = null;
    myLoveID = null;
    myLoveMissMe = null;
    notifyListeners();
  }
}