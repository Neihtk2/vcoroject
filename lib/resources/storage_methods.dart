import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> uploadImage(
      String childName, Uint8List image, bool isPost) async {
    final storageRef = FirebaseStorage.instance.ref();
    var ref = storageRef.child(childName).child(_auth.currentUser!.uid);
    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }
    final uploadTask = ref.putData(image);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
