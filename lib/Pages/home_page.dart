import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Auth/google_sign_in.dart';
import '../Data/counter.dart';
import '../Data/firebase_servicev2.dart';
import '../Data/nav_bar.dart';
import '../Data/page_control.dart';
import '../Data/user_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int currentPageIndex = PageControl.page;
  Counter counter = Counter();
  var myLoveMissMe = 0;
  var myLoveName = "";
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();
  final GoogleSignInHelper _googleSignIn = GoogleSignInHelper();

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var displayName = UserData.name;
    var formattedDate = DateFormat('MMMM dd, yyyy').format(now);
    counter.initCounter();
    int c = counter.getCounter();

    if(UserData.loveCheck == true){
      _dataFetcher.retrieveData(UserData.id, 'partner_id').then((value) {
        if (value != null) {
          print('myLoveID: $value');
          UserData.updateMyLoveID(value);
          _dataFetcher.retrieveData(UserData.myLoveID, 'user_name').then((value) {
            if (value != null) {
              print('First Name: $value');
              UserData.updateMyLoveName(value);
            } else {
              print('First name not found.');
            }
          });
          _dataFetcher.retrieveData(UserData.myLoveID, 'miss_counter').then((value) {
            if (value != null) {
              print('First Name: $value');
              UserData.updateMyLoveMissMe(value);
            } else {
              print('First name not found.');
            }
          });
        } else {
          print('myLoveID not found.');
          UserData.updateLoveCheck(false);
        }
      });
      myLoveName = UserData.myLoveName;
      myLoveMissMe = UserData.myLoveMissMe;
      _dataFetcher.retrieveData(UserData.id, "mood_pic").then((value) {
        setState(() {
          UserData.updateMoodPic(value);
        });
      });
    }

    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      appBar: AppBar(
        toolbarHeight: 250,
        title:  Text(
          "👋Hi $displayName,",
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(-30, 80),
            child: const CircleAvatar(
              backgroundImage: AssetImage(
                  "lib/Assets/Images/3.png"), // Replace with your image
              radius: 40, // Adjust the size as needed
            ),
            onSelected: (value) {
              // Handle menu item selection
              if (value == 'profile') {
                Navigator.pushReplacementNamed(context, '/profile');
              } else if (value == 'logout') {
                UserData.clearData();
                Counter().deleteCounter();
                _googleSignIn.handleSignOut(context);
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'profile',
                  child: Text('Profile'),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Log Out'),
                ),
              ];
            },
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        titleTextStyle:
            const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        backgroundColor: Colors.orange[100], // Make the app bar transparent
        elevation: 0, // Remove the shadow
      ),
      body: Container(
        color: Colors.orange[50],
        child: Column(
          children: [
            const SizedBox(height: 20,),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/memories');
                  },
                  heroTag: "btn1",
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.photo_size_select_actual_outlined,size: 100,),
                      SizedBox(height: 4), // Adjust the spacing as needed
                      Text('Memories'),
                    ],
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/calendar');
                  },
                  heroTag: "btn2",
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_month,size: 100,),
                      SizedBox(height: 4), // Adjust the spacing as needed
                      Text('Calendar'),
                    ],
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/emotion');
                  },
                  heroTag: "btn3",
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(UserData.moodPic),
                      SizedBox(height: 4), // Adjust the spacing as needed
                      Text('Emotion'),
                    ],
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      counter.incrementCounter();
                      c = counter.getCounter();
                      debugPrint("Pressed!");
                    });
                  },
                  heroTag: "btn4",
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('$myLoveName miss me $myLoveMissMe times :3', textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      const Icon(Icons.favorite,size: 100,),
                      const SizedBox(height: 4), // Adjust the spacing as needed
                      Text('I miss you $c'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
