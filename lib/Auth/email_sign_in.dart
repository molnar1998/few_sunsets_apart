import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Data/firebase_servicev2.dart';
import '../Data/user_data.dart';

class EmailPasswordAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        await _storeUID(user.uid); // Store UID in secure storage
        UserData.updateID(user.uid);
        UserData.updateName(user.displayName!);
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle login errors
    }
    return null;
  }

  Future<User?> signUp(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if(user != null){
        await _storeUID(user.uid);
        await user.updateDisplayName(UserData.name);
        _dataFetcher.saveData(user.uid, "user_name", UserData.name);
        UserData.updateID(user.uid);
        await FirebaseAuth.instance.setLanguageCode("fr");
        await user.sendEmailVerification().whenComplete(() {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Confirm your e-mail!'),
                content: Text('A conformation e-mail is sent to your $email e-mail address!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Okay'),
                    child: const Text('Okay'),
                  ),
                ],
              )
          );
        });
      }
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.message);
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Something went wrong!'),
            content: Text(e.code),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
            ],
          )
        );
      } // Handle error accordingly
      return null;
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _storeUID(String uid) async {
    final storage = FlutterSecureStorage();
    try {
      await storage.write(key: 'logged_in_uid', value: uid);
    } on PlatformException catch (e) {
      // Handle exceptions during storage operation
      if (kDebugMode) {
        print('Error storing UID: ${e.message}');
      }
    }
  }

}