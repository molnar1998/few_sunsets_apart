import 'package:few_sunsets_apart/Data/firebase_messaging_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/nav_bar.dart';
import '../Data/page_control.dart';
import '../Data/user_data.dart';
import '../Widgets/chat_card.dart';
import 'chat_page.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final FirebaseMessagingService _firebaseMessagingService = FirebaseMessagingService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: UserData.friends.length,
              itemBuilder: (context, index) {
                final friend = UserData.friends.elementAt(index);
                return StreamBuilder<String>(
                  stream: _firebaseMessagingService.getLastMessage(
                    _firebaseAuth.currentUser!.uid,
                    friend['friendId'],
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show a loading text while waiting for the message
                      return ChatCard(
                        friendName: friend['friendUId'],
                        lastMessage: 'Loading...',
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                receiverUserName: friend['friendUId'],
                                receiverUserID: friend['friendId'],
                              ),
                            ),
                          );
                          PageControl.updatePage('/message');
                        },
                      );
                    } else if (snapshot.hasError) {
                      return ChatCard(
                        friendName: friend['friendUId'],
                        lastMessage: 'Error loading message',
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                receiverUserName: friend['friendUId'],
                                receiverUserID: friend['friendId'],
                              ),
                            ),
                          );
                          PageControl.updatePage('/message');
                        },
                      );
                    } else {
                      return ChatCard(
                        friendName: friend['friendUId'],
                        lastMessage: snapshot.data ?? 'No message',
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                receiverUserName: friend['friendUId'],
                                receiverUserID: friend['friendId'],
                              ),
                            ),
                          );
                          PageControl.updatePage('/message');
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),

        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

}
