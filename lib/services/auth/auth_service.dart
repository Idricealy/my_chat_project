import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign in
  Future<UserCredential> signWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      //create a document for user
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'displayName' : _getDisplayName(userCredential.user!.email.toString()),
        'bio': ''
      }, SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // new user
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

            _firestore.collection('users').doc(userCredential.user!.uid).set({
              'id': userCredential.user!.uid,
              'displayName' : _getDisplayName(userCredential.user!.email.toString()),
              'bio': ''
            }, SetOptions(merge: true));
          return userCredential;
    }on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  //sign out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  String _getDisplayName(String email) {
    List<String> parts = email.split('@');
    return parts[0];
  }
}
