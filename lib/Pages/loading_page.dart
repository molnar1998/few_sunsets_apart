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
  bool _haveError = false;
  String _errorMessage = "";


  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Perform your async tasks here
      await getCurrentUserData();
    } catch (e, stackTrace) {
      // Handle errors here
      print('Error during initialization: $stackTrace');
      _haveError = true;
      _errorMessage = e.toString();

    } finally {
      setState(() {
        _isLoading = false;
        if (_haveError) {
          _haveError = false;
          Navigator.pushReplacementNamed(context, '/login');
          showDialog(context: context, builder: (BuildContext context){
            return StatefulBuilder(
                builder: (context, setState){
                  return AlertDialog(
                    title: Text("Error"),
                    content: Text(_errorMessage),
                  );
                }
            );
          });
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
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
      setState(() {
        _progressDisplay += 10;
        _progressValue += 0.1;
      });
      UserData.updateRequests(await _dataFetcher.retrieveData(user.uid, 'request'));
      setState(() {
        _progressDisplay += 10;
        _progressValue += 0.1;
      });
      UserData.updateMoodPic(await _dataFetcher.retrieveData(user.uid, "mood_pic"));
      setState(() {
        _progressDisplay += 10;
        _progressValue += 0.1;
      });
      UserData.updateMood(await _dataFetcher.retrieveData(user.uid, "mood"));
      setState(() {
        _progressDisplay += 10;
        _progressValue += 0.1;
      });
      await _dataFetcher.retrieveFriends(UserData.id).then((value){
        if(value != null){
          UserData.updateFriends(value);
        }
      });
      setState(() {
        _progressDisplay += 10;
        _progressValue += 0.1;
      });
      UserData.initCounter(await _dataFetcher.retrieveData(user.uid, "miss_counter"));
      setState(() {
        _progressDisplay += 10;
        _progressValue += 0.1;
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
      setState(() {
        _progressDisplay += 10;
        _progressValue += 0.1;
      });

      var prefs = await SharedPreferences.getInstance();
      var darkMode = prefs.getBool("darkMode");
      setState(() {
        _progressDisplay += 10;
        _progressValue += 0.1;
      });
      UserData.updateDarkMode(darkMode ?? false);
      setState(() {
        _progressDisplay += 10;
        _progressValue += 0.1;
      });
      try{
        UserData.updateProfilePic(await FirebaseStorage.instance.ref(UserData.id).getDownloadURL());
      } catch(e){
        UserData.updateProfilePic("lib/Assets/Images/3.png");
      }
      setState(() {
        _progressDisplay += 10;
        _progressValue += 0.1;
      });


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