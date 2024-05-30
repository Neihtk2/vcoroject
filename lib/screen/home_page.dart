import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvproject_flutter/chat/chat_screen.dart';
import 'package:cvproject_flutter/providers/user_provider.dart';
import 'package:cvproject_flutter/utils/colors.dart';
import 'package:cvproject_flutter/utils/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Image.asset(
          'assets/images/logo_app.png',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatScreen())),
              icon: Icon(Icons.message_outlined))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var a = snapshot.data;
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => FeedsCard(
                      snap: snapshot.data!.docs[index].data(),
                    ));
          }),
    );
  }
}
