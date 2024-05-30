import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvproject_flutter/chat/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('user').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // var a = snapshot.data.docs[1].data();
            return ListView.builder(
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) => _buildMessageItem(
                      (snapshot.data! as dynamic).docs[index],
                    ));
          }),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;
    if (FirebaseAuth.instance.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                  recceiverUserId: data['uid'],
                  recceiverUserEmail: data['email']),
            )),
      );
    } else
      return Container();
  }
}
