import 'dart:io';

import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:few_sunsets_apart/Data/push_notification_service.dart';
import 'package:few_sunsets_apart/Data/firebase_service.dart';
import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:few_sunsets_apart/Pages/chat_page.dart';
import 'package:few_sunsets_apart/Widgets/friend_card.dart';
import 'package:few_sunsets_apart/Widgets/request_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();
  final id = UserData.id;
  final myPartnerUsername = UserData.myLoveID;
  final _formKey = GlobalKey<FormState>();
  FilePickerResult? result;

  // Cloud Messaging variables
  late final FirebaseMessaging messaging;

  @override
  initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.requestPermission();
    FirebaseService().loadData();
    _getToken();
  }

  Future<dynamic> _getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    await _dataFetcher.saveData(id, 'id_token', fcmToken);
  }

  Future<void> _pickPictures() async {
    result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png']
    ).then((value) async {
      if(value != null){
        await FirebaseStorage.instance.ref(UserData.id).putFile(File(value.paths.first ?? "lib/Assets/Images/3.png"));
        UserData.updateProfilePic(await FirebaseStorage.instance.ref(UserData.id).getDownloadURL());
        setState(() {
        });
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: const Text('My Profile'),
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(-30, 80),
            child: CircleAvatar(
              backgroundImage: UserData.profilePic == "lib/Assets/Images/3.png" ? AssetImage("lib/Assets/Images/3.png") : Image.network(UserData.profilePic).image, // Replace with your image
              radius: 40, // Adjust the size as needed
            ),
            onSelected: (value) {
              // Handle menu item selection
              if (value == 'change_picture') {
                _pickPictures();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'change_picture',
                  child: Text('Change Picture'),
                ),
              ];
            },
          ),
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
          Text("My partner username: $myPartnerUsername"),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _usernameController,
              validator: (value) {
                if(value!.isEmpty){
                  return "Please enter your partner username first!";
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your partner username!',
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                if(_formKey.currentState!.validate()){
                  final token = await _dataFetcher.retrieveDataByUserName(_usernameController.text, 'id_token');
                  final uid = await _dataFetcher.retrieveUserId(_usernameController.text);
                  // Check permission
                  final permissionStatus = await Permission.notification.request();
                  if (permissionStatus.isGranted) {
                    await PushNotificationService.sendNotificationToSelectedPartner(token!, context, UserData.name, 'request');
                    await _dataFetcher.saveRequest(uid, UserData.name);
                  } else {
                    // Handle permission denied case (optional)
                    print('Notification permission denied');
                  }
                }
              },
              child: const Text("Add your partner!")),
          ElevatedButton(
            onPressed: () async {
              final fcmToken = await FirebaseMessaging.instance.getToken();
              print(fcmToken);
              await _dataFetcher.saveData(id, 'id_token', fcmToken);
            },
            child: const Text("Get my ID token!"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: UserData.requests.length,
              itemBuilder: (context, index) {
                final senderName = UserData.requests[index];
                return RequestCard(
                  senderName: senderName,
                  onAccept: () async {
                    await _dataFetcher.saveFriend(UserData.id, UserData.requests[index]);
                    await _dataFetcher.saveFriend(await _dataFetcher.retrieveUserId(UserData.requests[index]), UserData.name); //Save the user for the requesting partner too
                    await _dataFetcher.deleteRequest(UserData.id, UserData.requests[index]);
                    await FirebaseService().loadData();
                    setState(() {});
                  },
                  onDecline: () async {
                    await _dataFetcher.deleteRequest(UserData.id, UserData.requests[index]);
                    await FirebaseService().loadData();
                    setState(() {});
                  },
                );
              },
            ),
          ),
          const Text('Your Friends'),
          Expanded(
            child: ListView.builder(
                itemCount: UserData.friends.length,
                itemBuilder: (context, index) {
                  final friend = UserData.friends.elementAt(index);
                  return FriendCard(
                      friendName: friend.friendUId,
                      onSendMessage: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                  receiverUserName: friend.friendUId,
                                  receiverUserID: friend.friendId,
                              ),
                          ),
                        );
                      },
                      onDeleteFriend: () async {
                        await _dataFetcher.deleteFriend(UserData.id, UserData.requests[index]);
                        await FirebaseService().loadData();
                      },
                  );
                }),
          ),
        ],
      ),
      //TODO show list of friends
    );
  }
}
