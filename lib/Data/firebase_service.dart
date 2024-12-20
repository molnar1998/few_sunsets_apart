// firebase_service.dart


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:few_sunsets_apart/Data/user_data.dart';

class FirebaseService {
  CollectionReference usersCollections =
  FirebaseFirestore.instance.collection('users');
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();

  // Change counter value for everyone
  Future<void> resetCounterValues() async{
    FirebaseFirestore.instance.collection('users').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.update({
          'miss_you': 0 //Your new value
        });
      }
    });
  }

  Future<void> loadData() async {
    UserData.updateRequests(await _dataFetcher.retrieveData(UserData.id, 'request'));
    UserData.updateFriends(await _dataFetcher.retrieveFriends(UserData.id));
    //TODO Make all data loading in the same time!
  }
}
