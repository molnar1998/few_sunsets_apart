import 'package:few_sunsets_apart/Data/user_data.dart';

import 'firebase_servicev2.dart';

class Counter {
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();
  static int counter = 0;

  void incrementCounter(){
    counter++;
    _dataFetcher.saveData(UserData.id, "miss_counter", counter);
  }

  void initCounter() async {
    // Try to retrieve the data from Firebase
    final retrievedValue = await _dataFetcher.retrieveData(UserData.id, 'miss_counter');

    // Check if the data exists
    if (retrievedValue != null) {
      counter = retrievedValue;
    } else {
      // If data doesn't exist, set counter to default (0) and save it to Firebase
      counter = 0;
      await _dataFetcher.saveData(UserData.id, 'miss_counter', counter);
    }
  }
  int getCounter() => counter;

  void deleteCounter(){
    counter = 0;
  }
}