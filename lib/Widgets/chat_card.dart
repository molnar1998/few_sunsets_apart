import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final String friendName;
  final String lastMessage;
  final VoidCallback onTap;

  const ChatCard({
    super.key,
    required this.lastMessage,
    required this.friendName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                friendName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(lastMessage),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

}