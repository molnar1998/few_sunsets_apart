import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:few_sunsets_apart/Components/chat_bubble.dart';
import 'package:few_sunsets_apart/Components/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Data/firebase_messaging_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseMessagingService _firebaseMessagingService = FirebaseMessagingService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if(_messageController.text.isNotEmpty){
      await _firebaseMessagingService.sendMessage(widget.receiverUserID, _messageController.text);
      _messageController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail)),
      body: Column(
        children: [
          // messages
          Expanded(
              child: _buildMessageList(),
          ),

          // user input
          _buildMessageInput(),
        ],
      ),
    );
  }


  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _firebaseMessagingService.getMessages(
            widget.receiverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Text('Loading..');
          }

          return ListView(
            children: snapshot.data!.docs.
            map((document) => _buildMessageItem(document)).toList(),
          );
        },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the message to the right if the sender is the current use, otherwise to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
            (data['senderId'] == _firebaseAuth.currentUser!.uid)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            ChatBubble(message: data['message'])
          ],
        ),
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        // textfield
        Expanded(
            child: MyTextField(
                controller: _messageController,
                hintText: 'Enter message',
                obscureText: false
            ),
        ),
        // send buton
        IconButton(
          onPressed: sendMessage,
          icon: Icon(Icons.arrow_upward),
        )

      ],
    );
  }

}

