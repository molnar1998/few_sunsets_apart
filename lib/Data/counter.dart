import 'package:few_sunsets_apart/Data/user_data.dart';

import 'firebase_servicev2.dart';

class Counter {
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();
  static int counter = 0;

  void incrementCounter(String partnerUid){
    counter++;
    _dataFetcher.saveData(UserData.id, "miss_counter", {partnerUid : counter});

  }

  void initCounter() async {
    counter = UserData.counter;
  }

  int getCounter() => counter;

  void deleteCounter(){
    counter = 0;
  }
}