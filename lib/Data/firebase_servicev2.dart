import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseDataFetcher {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<dynamic> retrieveUserId(String username) async {
    try {
      // Query the collection to find the document with the desired username
      final querySnapshot = await users.where('user_name', isEqualTo: username).get();

      // Check if the query returned any results
      if (querySnapshot.docs.isNotEmpty) {
        // Extract the username from the first document
        final userDoc = querySnapshot.docs.first;
        return userDoc.id;
      } else {
        // Handle the case where no user with the given username was found
        throw Exception('User with username "$username" not found.');
      }
    } catch (e) {
      // Handle any errors that might occur during the query
      if (kDebugMode) {
        print('Error fetching username: $e');
      }
      rethrow; // Re-throw the exception for handling in the calling code
    }
  }

  Future<bool> checkUserNameAvailability(String username) async {
    try{
      // Query the collection to find the document with the desired username
      final querySnapshot = await users.where('user_name', isEqualTo: username).get();

      if(querySnapshot.docs.isEmpty) {
        return true;
      } else{
        return false;
      }

    } catch(e) {
      if (kDebugMode) {
        print('Error fetching username: $e');
      }
      rethrow;
    }
  }

  Future<dynamic> retrieveDataByUserName(String username, String field) async {
    try {
      // Query the collection to find the document with the desired username
      final querySnapshot = await users.where('user_name', isEqualTo: username).get();

      // Check if the query returned any results
      if (querySnapshot.docs.isNotEmpty) {
        // Extract the username from the first document
        final data = querySnapshot.docs.first[field];
        return data;
      } else {
        // Handle the case where no user with the given username was found
        throw Exception('User with username "$username" not found.');
      }
    } catch (e) {
      // Handle any errors that might occur during the query
      print('Error fetching username: $e');
      rethrow; // Re-throw the exception for handling in the calling code
    }
  }

  Future<dynamic> retrieveData(String userID, String field) async {
    // Fetches the document with the given userID from the users collection.
    DocumentSnapshot doc = await users.doc(userID).get();

    // Verifies if the document was found.
    if (doc.exists) {
      // Casts the document data to a Map<String, dynamic> for easier access.
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      // Checks if the field exists in the document data and is not null. If yes, it returns the value of the field.
      if (data != null && data.containsKey(field) && data[field] != null) {
        return data[field]; // Return the value of the specified field
      } else {
        // If the field is not found or is null, it prints a message and returns null.
        print('$field is not available in document with ID: $userID');
        return null;
      }
    } else {
      // If the document with userID does not exist, it prints a message and returns null.
      print('Document with ID: $userID does not exist.');
      return null;
    }
  }

  Future<void> saveData(String userId, String field, dynamic value) async {
    // Get a reference to the user document
    final docRef = users.doc(userId);

    // Prepare the data to be saved
    final dataToSave = {field: value}; // Create a Map with the field and value

    // Set data in the document
    await docRef.set(dataToSave, SetOptions(merge: true));

    print('Saved data: userId: $userId, field: $field, value: $value');
  }

  Future<void> saveFriend(String userId, String newFriendName) async {
    users
        .doc(userId)
        .collection('friends')
        .add({
      'friendUId': newFriendName,
      'friendId': await retrieveUserId(newFriendName),
      'timestamp': FieldValue.serverTimestamp(),
      // Any additional metadata
    });
    print('Saved data: userId: $userId, friend: $newFriendName');
  }

  Future<dynamic> retrieveFriends(String userId) async {

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('friends')
        .get();
    if(querySnapshot.size > 0){
      return querySnapshot.docs;
    } else{
      print("$userId don't have any friends :c");
      return null;
    }
  }

  Future<void> saveRequest(String userId, dynamic friendName) async {
    users
        .doc(userId)
        .update({
      'request': FieldValue.arrayUnion([friendName])
    });
    print('Saved data: userId: $userId, request: $friendName');
  }

  Future<void> deleteData(String userId, String data) async {
    users
        .doc('userId')
        .update({
      data: FieldValue.delete(),
    });
    print('Delete data: userId: $userId, field: $data');
  }

  Future<void> deleteFriend(String userId, String friendId) async {

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('friends')
        .where('friendId', isEqualTo: friendId)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
    if (kDebugMode) {
      print('Delete data: userId: $userId, friend: $friendId');
    }
  }

  Future<void> deleteRequest(String userId, dynamic friendId) async {
    users
        .doc(userId)
        .update({
      'request': FieldValue.arrayRemove([friendId])
    });
    if (kDebugMode) {
      print('Delete data: userId: $userId, request: $friendId');
    }
  }

  Future<void> deleteMemory(String userId, Timestamp timestamp)async {
    final snapshot = await _firestore.collection('memories')
        .doc(userId)
        .collection('memory')
        .where('createdAt', isEqualTo: timestamp)
        .get();
    for (var doc in snapshot.docs){
      await doc.reference.delete();
    }
    if(kDebugMode){
      print('Delete data: userId: $userId, memory $userId ${timestamp.toDate().toString()}');
    }
  }

  // GET MEMORIES
  Stream<QuerySnapshot> getMemories(String userId) {
    var Snapshot = _firestore
        .collection('memories')
        .doc(userId).collection('memory')
        .orderBy('createdAt', descending: false)
        .snapshots();

    return Snapshot;
  }

  Stream<QuerySnapshot> getSharedMemories(String userId) {
    // Step 1: Get all shared memories for the current user
    var snapshot = _firestore
        .collectionGroup('memory')
        .where('friends', arrayContains: userId)
        .snapshots();
    return snapshot;
  }
}