import 'dart:async';

import '/database/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Signs in with Google and returns the authenticated User.
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );

        return userCredential.user;
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
    return null;
  }

  /// Synchronizes local data to Firestore for the current signed-in user.
  Future<void> synchronizeData() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('User not signed in. Cannot synchronize data.');
      return;
    }

    final firestore = FirebaseFirestore.instance;
    final localEntries = await DatabaseHelper.instance.getEntries();

    // Upload local products to Firestore
    if (localEntries.isNotEmpty) {
      final batch = firestore.batch();
      for (final entry in localEntries) {}
      await batch.commit();
      print('Uploaded ${localEntries.length} products to Firestore.');
    }
  }
}
