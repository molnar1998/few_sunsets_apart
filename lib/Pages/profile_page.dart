import 'package:few_sunsets_apart/Data/firebase_fcm.dart';
import 'package:few_sunsets_apart/Data/firebase_service.dart';
import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _idController = TextEditingController();
  final FirebaseFCM _fcm = FirebaseFCM();
  final FirebaseService _firebaseService = FirebaseService();
  final id = UserData.id;
  final myLoveID = UserData.myLoveID;

  // Cloud Messaging variables
  late final FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              icon: const Icon(Icons.arrow_back_ios_new))
        ],
      ),
      body: Column(
        children: [
          Text("My ID: $id"),
          Text("My love: $myLoveID"),
          TextFormField(
            controller: _idController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your love ID!',
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                // Check permission
                final permissionStatus = await Permission.notification.request();
                if (permissionStatus.isGranted) {
                  await _fcm.sendRequest(_idController.text);
                } else {
                  // Handle permission denied case (optional)
                  print('Notification permission denied');
                }
              },
              child: const Text("Add your love!")),
        ],
      ),
    );
  }
}