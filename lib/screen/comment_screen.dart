import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvproject_flutter/mutel/users.dart' as model;

import 'package:cvproject_flutter/providers/user_provider.dart';
import 'package:cvproject_flutter/resources/firestore_methos.dart';
import 'package:cvproject_flutter/utils/colors.dart';
import 'package:cvproject_flutter/utils/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Comment'),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap)
              .collection('comments')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var a = snapshot;
            return ListView.builder(
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) => CommentCard(
                      snap: (snapshot.data! as dynamic).docs[index].data(),
                    ));
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl), radius: 18),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none),
                ),
              )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: InkWell(
                  onTap: () async {
                    await FirestoreMethods().postComment(
                        postId: widget.snap,
                        uid: user.uid,
                        text: _controller.text,
                        name: user.username,
                        profImage: user.photoUrl);
                    setState(() {
                      _controller.clear();
                    });
                  },
                  child: Text(
                    'Post',
                    style: TextStyle(color: blueColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
