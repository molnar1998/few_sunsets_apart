

class UserData {
  static String name = '';
  static String myLoveName = '';
  static String mood = "Happy";
  static String moodPic = "lib/Assets/Emotions/Happy.png";
  static String myLoveID = '';
  static String id = "";
  static int myLoveMissMe = 0;
  static bool loveCheck = true;
  static var requests = [];
  static var friends = [];
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
    myLoveName = name;
  }

  static void updateMyLoveMissMe(int missMe) {
    myLoveMissMe = missMe;
  }

  static void updateLoveCheck(bool check) {
    loveCheck = check;
  }

  static void updateMoodPic(String newMoodPic){
    moodPic = newMoodPic;
  }

  static void updateRequests(var newRequests){
    requests = newRequests;
  }

  static void updateFriends(var newFriends){
    if(newFriends != null) {
      for(var friend in newFriends){
        if(!friends.contains(friend['friendId'])){
          friends.add(friend['friendId']);
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
    myLoveName = '';
    mood = "Happy";
    myLoveID = '';
    id = "";
    myLoveMissMe = 0;
    loveCheck = true;
    moodPic = "lib/Assets/Emotions/Happy.png";
    requests = [];
    friends = [];
    counter = 0;
  }

}