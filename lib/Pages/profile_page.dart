import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:few_sunsets_apart/Data/page_control.dart';
import 'package:few_sunsets_apart/Data/push_notification_service.dart';
import 'package:few_sunsets_apart/Data/firebase_service.dart';
import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:few_sunsets_apart/Pages/chat_page.dart';
import 'package:few_sunsets_apart/Widgets/friend_card.dart';
import 'package:few_sunsets_apart/Widgets/request_card.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  // Cloud Messaging variables
  late final FirebaseMessaging messaging;

  @override
  initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.requestPermission();
    FirebaseService().loadData();
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
                    await PushNotificationService.sendNotificationToSelectedPartner(token, context, UserData.name, 'request');
                    await _dataFetcher.saveRequest(uid, UserData.name);
                  } else {
                    // Handle permission denied case (optional)
                    print('Notification permission denied');
                  }
                }
              },
              child: const Text("Add your partner!")),
          /**ElevatedButton(
            onPressed: () async {
              final fcmToken = await FirebaseMessaging.instance.getToken();
              print(fcmToken);
              await _dataFetcher.saveData(id, 'id_token', fcmToken);
            },
            child: const Text("Get my ID token!"),
          ),**/
          Expanded(
            child: ListView.builder(
              itemCount: UserData.requests.length,
              itemBuilder: (context, index) {
                final senderName = UserData.requests[index];
                return RequestCard(
                  senderName: senderName,
                  onAccept: () async {
                    await _dataFetcher.saveFriend(UserData.id, UserData.requests[index]);
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
                      friendName: friend['friendUId'],
                      onSendMessage: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                  receiverUserName: friend['friendUId'],
                                  receiverUserID: friend['friendId'],
                              ),
                          ),
                        );
                      },
                      onDeleteFriend: () async {
                        await _dataFetcher.deleteRequest(UserData.id, UserData.requests[index]);
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
