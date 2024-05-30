import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvproject_flutter/mutel/users.dart';

import 'package:cvproject_flutter/providers/user_provider.dart';
import 'package:cvproject_flutter/resources/firestore_methos.dart';
import 'package:cvproject_flutter/utils/colors.dart';
import 'package:cvproject_flutter/utils/like_animation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profImage']),
            radius: 18,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(
                        style: TextStyle(color: primaryColor),
                        children: [
                      TextSpan(
                          text: widget.snap['name'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: '  ${widget.snap['text']}',
                      )
                    ])),
                Text(
                  DateFormat.yMMMd().format(
                      (widget.snap['datePublished'] as Timestamp).toDate()),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                )
              ],
            ),
          )),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likeComment(
                          postId: widget.snap['postId'],
                          uid: _user.uid,
                          like: widget.snap['likes'],
                          commentId: widget.snap['commentId']);
                    },
                    icon: (widget.snap['likes'])!.contains(_user.uid) == false
                        ? Icon(
                            Icons.favorite_border,
                            size: 12,
                          )
                        : Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 12,
                          )),
                Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  child: Text('${widget.snap['likes'].length}',
                      style: Theme.of(context).textTheme.bodyMedium),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
