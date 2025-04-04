import 'dart:math';

import 'package:few_sunsets_apart/Data/firebase_service.dart';
import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingPage extends StatefulWidget {
  final Widget homePage;

  const LoadingPage({
    super.key,
    required this.homePage,
  });

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();
  double _progressValue = 0;
  double _progressDisplay = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Simulate async tasks and update progress
      for (int i = 0; i <= 100; i++) {
        await Future.delayed(Duration(milliseconds: 10));
        setState(() {
          _progressValue = i / 100;
          _progressDisplay = _progressValue * 100;
        });
      }

      // Perform your async tasks here
      await getCurrentUserData();
    } catch (e) {
      // Handle errors here
      print('Error during initialization: $e');
    } finally {
      setState(() {
        _isLoading = false;
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  Future<void> getCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is signed in, retrieve their information
      String uid = user.uid; // Unique ID for the user
      String? email = user.email; // User's email address
      String? displayName = user.displayName; // User's display name, if set
      String? photoURL = user.photoURL; // User's profile picture URL, if set

      UserData.updateID(uid);
      UserData.updateRequests(await _dataFetcher.retrieveData(user.uid, 'request'));
      UserData.updateMoodPic(await _dataFetcher.retrieveData(user.uid, "mood_pic"));
      UserData.updateMood(await _dataFetcher.retrieveData(user.uid, "mood"));
      UserData.updateCounter(await _dataFetcher.retrieveData(user.uid, "miss_counter"));
      await _dataFetcher.retrieveFriends(UserData.id).then((value){
        if(value != null){
          UserData.updateFriends(value);
        }
      });

      await _dataFetcher.retrieveData(user.uid, "user_name").then((value) async {
        if(value == null && await _dataFetcher.checkUserNameAvailability(displayName!)){
          _dataFetcher.saveData(user.uid, "user_name", displayName);
          UserData.updateName(await _dataFetcher.retrieveData(user.uid, "user_name"));
        } else if (value == null){
          var newUserName = "User${Random().nextInt(1000)}";
          if(await _dataFetcher.checkUserNameAvailability(newUserName)){
            _dataFetcher.saveData(user.uid, "user_name", newUserName);
            UserData.updateName(await _dataFetcher.retrieveData(user.uid, "user_name"));
          }
        } else {
          UserData.updateName(await _dataFetcher.retrieveData(user.uid, "user_name"));
        }
      });

      var prefs = await SharedPreferences.getInstance();
      UserData.updateDarkMode(prefs.getBool("darkMode") ?? false);
      UserData.updateProfilePic(FirebaseStorage.instance.ref(UserData.id).fullPath != UserData.id ? "lib/Assets/Images/3.png" : await FirebaseStorage.instance.ref(UserData.id).getDownloadURL());


      print("User UID: $uid");
      print("User Email: $email");
      print("User Display Name: $displayName");
      print("User Photo URL: $photoURL");
    } else {
      // No user is signed in
      print("No user is currently signed in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(value: _progressValue),
            SizedBox(height: 20),
            Text('Loading... $_progressDisplay%'),
          ],
        ),
      ),
    );
  }
}