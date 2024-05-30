import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvproject_flutter/chat/messenge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class ChatServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> sendMessage(String receiverId, String mess) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestap = Timestamp.now();
    String messegeId = Uuid().v1();
    Messenge newmessenge = Messenge(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        messege: mess,
        timestamp: timestap,
        messegeId: messegeId);
    List<String> ids = [receiverId, currentUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messenges')
        .doc(messegeId)
        .set(newmessenge.toMap());
  }

  Stream<QuerySnapshot> getMessanges(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messenges')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> deleteMessage(String userId, String otherUserId) async {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    try {
      _firestore.collection('chat_rooms').doc(chatRoomId).delete();
    } catch (e) {
      print(e.toString());
    } 
  }
}
