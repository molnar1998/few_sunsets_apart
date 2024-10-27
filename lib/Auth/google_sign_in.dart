import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Data/user_data.dart';

class GoogleSignInHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    //Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    //Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void handleSignOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
    }
    catch (e) {
      return null;
    }
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
