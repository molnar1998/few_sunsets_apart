import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataFetcher {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<dynamic> retrieveUser(String userID) async {
    // Fetches the document with the given userID from the users collection.
    DocumentSnapshot doc = await users.doc(userID).get();

    // Verifies if the document was found.
    if (doc.exists) {
      // Casts the document data to a Map<String, dynamic> for easier access.
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      return data;
    } else {
      // If the document with userID does not exist, it prints a message and returns null.
      print('Document with ID: $userID does not exist.');
      return null;
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
    await docRef.set(dataToSave);

    print('Saved data: userId: $userId, field: $field, value: $value');
  }
}