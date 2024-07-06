import 'package:few_sunsets_apart/Data/user_data.dart';

import 'firebase_service.dart';
import 'firebase_servicev2.dart';

class Counter {
  final firebaseService = FirebaseService();
  final firebaseDataFetcher = FirebaseDataFetcher();
  static int counter = 0;

  void incrementCounter(){
    counter++;
    firebaseService.saveCounterValue(counter);
  }

  void initCounter() async {
    // Try to retrieve the data from Firebase
    final retrievedValue = await firebaseDataFetcher.retrieveData(UserData.id, 'miss_you');

    // Check if the data exists
    if (retrievedValue != null) {
      counter = retrievedValue;
    } else {
      // If data doesn't exist, set counter to default (0) and save it to Firebase
      counter = 0;
      await firebaseDataFetcher.saveData(UserData.id, 'miss_you', counter);
    }
  }
  int getCounter() => counter;

  void deleteCounter(){
    counter = 0;
  }
}