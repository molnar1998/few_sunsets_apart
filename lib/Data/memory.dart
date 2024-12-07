import 'package:cloud_firestore/cloud_firestore.dart';

class Memory {
  final String imagePath;
  final String text;
  final String title;
  final DateTime date;
  final Timestamp createdAt;

  Memory({
    required this.imagePath,
    required this.text,
    required this.title,
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'imagePath' : imagePath,
      'text' : text,
      'title': title,
      'date' : date,
      'createdAt' : createdAt,
    };
  }

}