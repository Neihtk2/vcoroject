// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Messenge {
  final String messegeId;
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String messege;
  final Timestamp timestamp;
  Messenge({
    required this.messegeId,
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.messege,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messegeId': messegeId,
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'messege': messege,
      'timestamp': timestamp,
    };
  }

  factory Messenge.fromMap(Map<String, dynamic> map) {
    return Messenge(
      messegeId: map['messegeId'] as String,
      senderId: map['senderId'] as String,
      senderEmail: map['senderEmail'] as String,
      receiverId: map['receiverId'] as String,
      messege: map['messege'] as String,
      timestamp: map['timestamp'],
    );
  }
}
