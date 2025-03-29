import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  final String friendId;
  final String friendUId;
  final Timestamp timestamp;

  Friend({
    required this.friendId,
    required this.friendUId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'friendId': friendId,
      'friendUId': friendUId,
      'timestamp': timestamp,
    };
  }
}