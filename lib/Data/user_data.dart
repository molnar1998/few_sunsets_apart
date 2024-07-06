import 'package:few_sunsets_apart/Data/firebase_service.dart';


class UserData {
  static String name = '';
  static String myLoveName = '';
  static String mood = "Happy";
  static String myLoveID = '';
  static String id = "";
  static int myLoveMissMe = 0;

  // Setter method to update the user's name
  static void updateName(String newName) {
    FirebaseService firebaseService = FirebaseService();
    name = newName;
    firebaseService.saveData('my_name', newName);
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
    myLoveName = name;
  }

  static void updateMyLoveMissMe(int missMe) {
    myLoveMissMe = missMe;
  }

  static void clearData(){
    name = '';
    myLoveName = '';
    mood = "Happy";
    myLoveID = '';
    id = "";
    myLoveMissMe = 0;
  }

}