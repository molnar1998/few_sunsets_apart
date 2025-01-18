import 'dart:async';

import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Data/user_data.dart';

class GoogleSignInHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();
  GoogleSignInAccount? googleUser;

  static const List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly'
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopes,
  );

  Future<void> canAccess() async{
    _googleSignIn.isSignedIn().then((value) {
      if (kDebugMode) {
        print(value);
      }
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  void handleSignOut(BuildContext context) async {
    _googleSignIn.signOut();
  }

  Future<void> _storeUID(String uid) async {
    const storage = FlutterSecureStorage();
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
