import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvproject_flutter/mutel/postclass.dart';
import 'package:cvproject_flutter/resources/storage_methods.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = 'have a error';
    try {
      String photoUrl = await StorageMethods().uploadImage('posts', file, true);
      String postId = Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'succes';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> postComment(
      {required String postId,
      required String uid,
      required String text,
      required String name,
      required String profImage}) async {
    try {
      if (text.isNotEmpty) {
        String idComment = Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(idComment)
            .set({
          'profImage': profImage,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': idComment,
          'datePublished': DateTime.now(),
          'likes': [],
          'postId': postId
        });
        print('Thanh cong');
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print('Chua duoc dau ${e.toString()}');
    }
  }

  Future<void> likePost(
      {required String postId, required String uid, required List like}) async {
    try {
      if (like.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print('Chua duoc dau ${e.toString()}');
    }
  }

  Future<void> follower(
      {required String uid,
      required String followId,
      required List folower}) async {
    try {
      if (folower.contains(followId)) {
        await _firestore.collection('user').doc(uid).update({
          'followers': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('user').doc(uid).update({
          'followers': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print('Chua duoc dau ${e.toString()}');
    }
  }

  Future<void> following(
      {required String uid,
      required String followId,
      required List folowing}) async {
    try {
      if (folowing.contains(uid)) {
        await _firestore.collection('user').doc(followId).update({
          'following': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('user').doc(followId).update({
          'following': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print('Chua duoc dau ${e.toString()}');
    }
  }

  Future<void> likeComment(
      {required String postId,
      required String commentId,
      required String uid,
      required List like}) async {
    try {
      if (like.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print('Chua duoc dau ${e.toString()}');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
