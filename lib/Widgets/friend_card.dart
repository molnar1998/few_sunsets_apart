import 'package:flutter/material.dart';

class FriendCard extends StatelessWidget {
  final String friendName;
  final VoidCallback onSendMessage;
  final VoidCallback onDeleteFriend;

  const FriendCard({
    super.key,
    required this.friendName,
    required this.onSendMessage,
    required this.onDeleteFriend,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: onSendMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Message'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: onDeleteFriend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}