import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvproject_flutter/mutel/users.dart' as model;
import 'package:cvproject_flutter/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    var snap = await _firestore.collection('user').doc(currentUser.uid).get();
    var a = snap.data();
    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser(
      {required String mail,
      required String pass,
      required String name,
      required String bio,
      required Uint8List? file}) async {
    String res = "have error";
    String photoUrl =
        'https://lh4.ggpht.com/-6yT-qebBM-4/V5u4e0-QNVI/AAAAAABviw0/kczUi-RDiEI/w1000-h800/image';
    try {
      if (mail.isNotEmpty ||
          pass.isNotEmpty ||
          name.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: mail, password: pass);
        print(cred.user!.uid);
        if (file != null) {
          photoUrl =
              await StorageMethods().uploadImage('profilePics', file, false);
        }
        model.User user = model.User(
          bio: bio,
          email: mail,
          uid: cred.user!.uid,
          followers: [],
          photoUrl: photoUrl,
          username: name,
          following: [],
        );
        await _firestore.collection('user').doc(cred.user!.uid).set(
            //   {
            //   'username': name,
            //   'uid': cred.user!.uid,
            //   'email': mail,
            //   'bio': bio,
            //   'followers': [],
            //   'following': [],
            //   'photoUrl': photoUrl
            // }
            user.toJson());
        res = "succes";
      }
    } catch (e) {
      return res;
    }
    ;
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> LoginUser(
      {required String maill, required String pass}) async {
    String res = 'Have error';
    try {
      if (maill.isNotEmpty || pass.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: maill, password: pass);
        res = 'succes';
      } else {
        res = 'Mời điền vào form';
      }
    } catch (e) {
      return res.toString();
    }
    return res;
  }
}
