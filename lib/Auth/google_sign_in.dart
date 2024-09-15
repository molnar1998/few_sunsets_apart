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

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      else {

      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      await _storeUID(authResult.user!.uid);
      UserData.updateID(authResult.user!.uid);
      _dataFetcher.saveData(authResult.user!.uid, "user_name", googleUser.displayName);
      return authResult.user;
    } catch (e) {
      if (kDebugMode) {
        print('Google sign-in error: $e');
      }
      return null;
    }
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
      print('Error storing UID: ${e.message}');
    }
  }

}
